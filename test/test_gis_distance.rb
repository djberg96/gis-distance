require 'test/unit'
require 'gis/distance'

class TC_GIS_Distance < Test::Unit::TestCase
   def setup
      @gis = GIS::Distance.new(40.47, 73.58, 34.3, 118.15)
   end

   def test_distance_basic_functionality
      assert_respond_to(@gis, :distance)
      assert_nothing_raised{ @gis.distance }
      assert_kind_of(Float, @gis.distance)
   end

   def teardown
      @gis = nil
   end
end
