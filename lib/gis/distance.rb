# frozen_string_literal: true

# The GIS module serves as a namespace only.
module GIS
  # The Distance class encapsulates methods related to geographic distance.
  class Distance
    # Error raised if latitude or longitude values are invalid.
    class Error < StandardError; end

    # The version of the gis-distance library
    VERSION = '1.2.0'

    # Earth radius bounds in kilometers
    MIN_EARTH_RADIUS = 6357.0
    MAX_EARTH_RADIUS = 6378.0
    DEFAULT_EARTH_RADIUS = 6367.45

    # Supported distance calculation formulas
    SUPPORTED_FORMULAS = %w[haversine cosines vincenty].freeze

    # Conversion factor from kilometers to miles
    KM_TO_MILES_FACTOR = 0.621371192

    # Degree to radian conversion factor
    DEG_TO_RAD = Math::PI / 180

    # Create a new GIS::Distance object using the two sets of coordinates
    # that are provided.
    #
    # If invalid coordinates are provided a GIS::Distance::Error is raised.
    #
    def initialize(latitude1, longitude1, latitude2, longitude2)
      validate_coordinates(latitude1, longitude1, latitude2, longitude2)

      @latitude1  = latitude1.to_f
      @longitude1 = longitude1.to_f
      @latitude2  = latitude2.to_f
      @longitude2 = longitude2.to_f

      @radius   = DEFAULT_EARTH_RADIUS
      @formula  = 'haversine'
      @distance_cache = {}
    end

    # Returns the radius of the Earth in kilometers. The default is 6367.45.
    #
    attr_reader :radius

    # Sets the radius of the Earth in kilometers. This is variable because
    # the Earth is not perfectly spherical, and you may wish to adjust it.
    #
    # However, the possible range of values is limited from 6357.0 to 6378.0.
    # If a value outside of this range is provided a GIS::Distance::Error
    # is raised.
    #
    # The default value is 6367.45.
    #
    # See http://en.wikipedia.org/wiki/Earth_radius for more information.
    #
    def radius=(kms)
      kms = kms.to_f
      unless kms.between?(MIN_EARTH_RADIUS, MAX_EARTH_RADIUS)
        raise Error, "Proposed radius '#{kms}' is out of range (#{MIN_EARTH_RADIUS}-#{MAX_EARTH_RADIUS})"
      end

      clear_distance_cache if @radius != kms
      @radius = kms
    end

    # Returns the formula used to calculate the distance. The default formula
    # is 'haversine'.
    #--
    # See http://en.wikipedia.org/wiki/Haversine_formula for details.
    attr_reader :formula

    # Sets the formula to be used internally for calculating the distance.
    # The default is 'haversine'. Your other options are 'cosines' (i.e. the
    # Law of Cosines) and 'vincenty' (Vincenty's formulae).
    #
    # If an unsupported formula is provided a GIS::Distance::Error is raised.
    #
    def formula=(formula)
      formula_str = formula.to_s.downcase

      unless SUPPORTED_FORMULAS.include?(formula_str)
        raise Error, "Formula '#{formula}' not supported. Supported formulas: #{SUPPORTED_FORMULAS.join(', ')}"
      end

      clear_distance_cache if @formula != formula_str
      @formula = formula_str
    end

    # Returns the distance (in kilometers) between the two coordinates
    # provided in the constructor. Results are cached for performance.
    #
    def distance
      cache_key = "#{@formula}_#{@radius}"
      @distance_cache[cache_key] ||= calculate_distance
    end

    private

    # Calculate distance using the selected formula
    def calculate_distance
      case @formula
        when 'haversine'
          haversine_formula
        when 'cosines'
          law_of_cosines_formula
        when 'vincenty'
          vincenty_formula
        else
          raise Error, "Unknown formula: #{@formula}"
      end
    end

    # Clear the distance cache when radius or formula changes
    def clear_distance_cache
      @distance_cache.clear
    end

    # Validate coordinate inputs for type and range
    def validate_coordinates(lat1, lon1, lat2, lon2)
      coordinates = [lat1, lon1, lat2, lon2]

      # Check if all coordinates are numeric
      coordinates.each_with_index do |coord, index|
        coord_name = index.even? ? 'Latitude' : 'Longitude'
        raise Error, "#{coord_name} '#{coord}' must be numeric" unless coord.is_a?(Numeric)
      end

      # Validate latitude ranges
      [lat1, lat2].each do |lat|
        raise Error, "Latitude '#{lat}' is invalid - must be between -90 and 90" unless lat.between?(-90, 90)
      end

      # Validate longitude ranges
      [lon1, lon2].each do |lon|
        raise Error, "Longitude '#{lon}' is invalid - must be between -180 and 180" unless lon.between?(-180, 180)
      end
    end

    # See https://en.wikipedia.org/wiki/Law_of_cosines
    #
    def law_of_cosines_formula
      # Convert to radians
      lat1_rad = @latitude1 * DEG_TO_RAD
      lat2_rad = @latitude2 * DEG_TO_RAD
      lon_diff_rad = (@longitude2 - @longitude1) * DEG_TO_RAD

      # Pre-calculate trigonometric values
      sin1 = Math.sin(lat1_rad)
      sin2 = Math.sin(lat2_rad)
      cos1 = Math.cos(lat1_rad)
      cos2 = Math.cos(lat2_rad)
      cos_lon_diff = Math.cos(lon_diff_rad)

      # Law of cosines formula
      central_angle = Math.acos((sin1 * sin2) + (cos1 * cos2 * cos_lon_diff))
      radius * central_angle
    end

    # See http://en.wikipedia.org/wiki/Haversine_formula
    #
    def haversine_formula
      # Convert to radians
      lat1_rad = @latitude1 * DEG_TO_RAD
      lon1_rad = @longitude1 * DEG_TO_RAD
      lat2_rad = @latitude2 * DEG_TO_RAD
      lon2_rad = @longitude2 * DEG_TO_RAD

      # Calculate differences
      dlat = lat2_rad - lat1_rad
      dlon = lon2_rad - lon1_rad

      # Haversine formula
      a = (Math.sin(dlat / 2)**2) + (Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon / 2)**2))
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      radius * c
    end

    # See https://en.wikipedia.org/wiki/Vincenty's_formulae
    def vincenty_formula
      require 'rvincenty'
      RVincenty.distance([@latitude1, @longitude1], [@latitude2, @longitude2]) / 1000.0
    rescue LoadError => e
      raise Error, "RVincenty gem required for Vincenty formula: #{e.message}"
    end
  end

  # Extensions module for adding distance conversion methods
  module DistanceExtensions
    # Convert kilometers to miles
    def mi
      self * Distance::KM_TO_MILES_FACTOR
    end
  end
end

# Extend Float class with distance conversion methods if not already defined
class Float
  include GIS::DistanceExtensions unless respond_to?(:mi)
end
