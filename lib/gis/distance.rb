# The GIS module serves as a namespace only.
module GIS
   # The Distance class encapsulates methods related to geographic distance.
   class Distance
      # Error raised if latitude or longitude values are invalid.
      class Error < StandardError; end

      # The version of the gis-distance library
      VERSION = '0.1.0'

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

         @radius  = 6367.45
         @formula = 'haversine'
      end

      # Returns the radius of the Earth in kilometers. The default is 6367.45.
      #
      def radius
         @radius
      end

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
         if kms < 6357.0 || kms > 6378.0
            raise Error, "Proposed radius '#{kms}' is out of range" 
         end
         @radius = kms
      end

      # Returns the formula used to calculate the distance. The default formula
      # is 'haversine'.
      #--
      # See http://en.wikipedia.org/wiki/Haversine_formula for details.
      def formula
         @formula
      end

      # Sets the formula to be used internally for calculating the distance.
      # The default is 'haversine'.
      #
      # If an unsupported formula is provided a GIS::Distance::Error is raised.
      #
      def formula=(formula)
         case formula.to_s.downcase
            when 'haversine'
               @formula = 'haversine'
         else
            raise Error, "Formula '#{formula}' not supported"
         end
      end

      # Returns the distance (in kilometers) between the two coordinates
      # provided in the constructor.
      #
      def distance
         case @formula.to_s.downcase
            when 'haversine'
               haversine_formula
         end
      end

      private

      # Validate the latitude and longitude values. Latitudes must be between
      # 90.0 and -90.0 while longitudes must be between 180.0 and -180.0.
      #
      def validate(lat1, lon1, lat2, lon2)
         [lat1, lat2].each{ |lat|
            if lat > 90 || lat < -90
               msg = "Latitude '#{lat}' is invalid - must be between -90 and 90"
               raise Error, msg
            end
         }

         [lon1, lon2].each{ |lon|
            if lon > 180 || lon < -180
               msg = "Longitude '#{lon}' is invalid - must be between -180 and 180"
               raise Error, msg
            end
         }
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

         a = ((Math.sin(dlat/2))**2) + (Math.cos(lat1) * Math.cos(lat2) * (Math.sin(dlon/2)) ** 2)
         c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

         @radius * c
      end
   end
end
