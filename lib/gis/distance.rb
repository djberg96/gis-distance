# frozen_string_literal: true

# The GIS module serves as a namespace only.
module GIS
  # The Distance class encapsulates methods related to geographic distance.
  class Distance
    # Error raised if latitude or longitude values are invalid.
    class Error < StandardError; end

    # The version of the gis-distance library
    VERSION = '1.1.0'

    # Create a new GIS::Distance object using the two sets of coordinates
    # that are provided.
    #
    # If invalid coordinates are provided a GIS::Distance::Error is raised.
    #
    def initialize(latitude1, longitude1, latitude2, longitude2)
      validate(latitude1, longitude1, latitude2, longitude2)

      @latitude1  = latitude1
      @longitude1 = longitude1
      @latitude2  = latitude2
      @longitude2 = longitude2

      @radius   = 6367.45
      @formula  = 'haversine'
      @distance = nil
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
      raise Error, "Proposed radius '#{kms}' is out of range" if kms < 6357.0 || kms > 6378.0
      @radius = kms
    end

    # Returns the formula used to calculate the distance. The default formula
    # is 'haversine'.
    #--
    # See http://en.wikipedia.org/wiki/Haversine_formula for details.
    attr_reader :formula

    # Sets the formula to be used internally for calculating the distance.
    # The default is 'haversine'. Your other option is 'cosines' (i.e. the
    # Law of Cosines).
    #
    # If an unsupported formula is provided a GIS::Distance::Error is raised.
    #
    def formula=(formula)
      case formula.to_s.downcase
        when 'haversine'
          @formula = 'haversine'
        when 'cosines'
          @formula = 'cosines'
        when 'vincenty'
          @formula = 'vincenty'
        else
          raise Error, "Formula '#{formula}' not supported"
      end
    end

    # Returns the distance (in kilometers) between the two coordinates
    # provided in the constructor.
    #
    def distance
      @distance =
        case @formula.to_s.downcase
          when 'haversine'
            haversine_formula
          when 'cosines'
            law_of_cosines_formula
          when 'vincenty'
            vincenty_formula
        end
    end

    private

    # Validate the latitude and longitude values. Latitudes must be between
    # 90.0 and -90.0 while longitudes must be between 180.0 and -180.0.
    #
    def validate(lat1, lon1, lat2, lon2)
      [lat1, lat2].each do |lat|
        if lat > 90 || lat < -90
          msg = "Latitude '#{lat}' is invalid - must be between -90 and 90"
          raise Error, msg
        end
      end

      [lon1, lon2].each do |lon|
        if lon > 180 || lon < -180
          msg = "Longitude '#{lon}' is invalid - must be between -180 and 180"
          raise Error, msg
        end
      end
    end

    # See https://en.wikipedia.org/wiki/Law_of_cosines
    #
    def law_of_cosines_formula
      sin1 = Math.sin(@latitude1 * Math::PI / 180)
      sin2 = Math.sin(@latitude2 * Math::PI / 180)
      cos1 = Math.cos(@latitude1 * Math::PI / 180)
      cos2 = Math.cos(@latitude2 * Math::PI / 180)
      cos3 = Math.cos((@longitude2 * Math::PI / 180) - (@longitude1 * Math::PI / 180))

      Math.acos((sin1 * sin2) + (cos1 * cos2 * cos3)) * radius
    end

    # See http://en.wikipedia.org/wiki/Haversine_formula
    #
    def haversine_formula
      lat1 = @latitude1  * Math::PI / 180
      lon1 = @longitude1 * Math::PI / 180
      lat2 = @latitude2  * Math::PI / 180
      lon2 = @longitude2 * Math::PI / 180

      dlat = lat2 - lat1
      dlon = lon2 - lon1

      a = (Math.sin(dlat / 2)**2) + (Math.cos(lat1) * Math.cos(lat2) * (Math.sin(dlon / 2)**2))
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      radius * c
    end

    # See https://en.wikipedia.org/wiki/Vincenty's_formulae
    def vincenty_formula
      require 'bigdecimal'
      require 'bigdecimal/util'

      # WGS-84 ellipsiod parameters
      a = 6378137.0
      f = 1 / 298.257223563
      b = (1 - f) * a

      # Convert degrees to radians
      lat1 = @latitude1.to_d * Math::PI / 180
      lon1 = @longitude1.to_d * Math::PI / 180
      lat2 = @latitude2.to_d * Math::PI / 180
      lon2 = @longitude2.to_d * Math::PI / 180

      # Differences in coordinates
      big_l = lon2 - lon1
      u1 = Math.atan((1 - f) * Math.tan(lat1))
      u2 = Math.atan((1 - f) * Math.tan(lat2))

      sin_u1 = Math.sin(u1)
      cos_u1 = Math.cos(u1)
      sin_u2 = Math.sin(u2)
      cos_u2 = Math.cos(u2)

      λ = big_l
      lambda_p = 2 * Math::PI
      iterLimit = 100

      while (λ - lambda_p).abs > 1e-12 && iterLimit > 0
        sin_lambda = Math.sin(λ)
        cos_lambda = Math.cos(λ)
        sin_sigma = Math.sqrt((cos_u2 * sin_lambda) ** 2 + (cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda) ** 2)
        cos_sigma = sin_u1 * sin_u2 + cos_u1 * cos_u2 * cos_lambda
        sigma = Math.atan2(sin_sigma, cos_sigma)
        sin_alpha = cos_u1 * cos_u2 * sin_lambda / sin_sigma
        cos2_alpha = 1 - sin_alpha ** 2
        cos2_sigma_m = cos_sigma - 2 * sin_u1 * sin_u2 / cos2_alpha
        big_c = f / 16 * cos2_alpha * (4 + f * (4 - 3 * cos2_alpha))
        lambda_p = λ
        λ = big_l + (1 - big_c) * f * sin_alpha * (sigma + big_c * sin_sigma * (cos2_sigma_m + big_c * cos_sigma * (-1 + 2 * cos2_sigma_m ** 2)))
        iterLimit -= 1
      end

      if iterLimit == 0
        return nil # formula failed to converge
      end

      u2 = cos2_alpha * (a ** 2 - b ** 2) / (b ** 2)
      big_a = 1 + u2 / 16384 * (4096 + u2 * (-768 + u2 * (320 - 175 * u2)))
      big_b = u2 / 1024 * (256 + u2 * (-128 + u2 * (74 - 47 * u2)))
      delta_sigma = big_b * sin_sigma * (cos2_sigma_m + big_b / 4 * (cos_sigma * (-1 + 2 * cos2_sigma_m ** 2) - big_b / 6 * cos2_sigma_m * (-3 + 4 * sin_sigma ** 2) * (-3 + 4 * cos2_sigma_m ** 2)))

      s = b * big_a * (sigma - delta_sigma)

      s.to_f / 1000.0
    end

    # Add a custom method to the base Float class if it isn't already defined.
    class ::Float
      unless respond_to?(:mi)
        # Convert miles to kilometers.
        def mi
          self * 0.621371192
        end
      end
    end
  end
end
