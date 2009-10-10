require 'test/unit'
require 'gis/distance'

class TC_GIS_Distance < Test::Unit::TestCase
   def setup
      @gis = GIS::Distance.new(40.47, 73.58, 34.3, 118.15)
   end

   def test_version
      assert_equal('1.0.0', GIS::Distance::VERSION)
   end

   def test_distance_basic_functionality
      assert_respond_to(@gis, :distance)
      assert_nothing_raised{ @gis.distance }
      assert_kind_of(Float, @gis.distance)
   end

   def test_distance
      assert_in_delta(0.01, 3952.39, @gis.distance)
      assert_equal(0.0, GIS::Distance.new(40.47, 73.58, 40.47, 73.58).distance)
   end

   def test_distance_expected_argument_errors
      assert_raise(ArgumentError){ GIS::Distance.new }
      assert_raise(ArgumentError){ GIS::Distance.new(40.47) }
      assert_raise(ArgumentError){ GIS::Distance.new(40.47, 73.58) }
      assert_raise(ArgumentError){ GIS::Distance.new(40.47, 73.58, 34.3) }
   end

   def test_distance_expected_range_errors
      assert_raise(GIS::Distance::Error){ GIS::Distance.new(91.0, 100.0, 45.0, 45.0) }
      assert_raise(GIS::Distance::Error){ GIS::Distance.new(90.0, 190.0, 45.0, 45.0) }
   end

   def test_radius_basic_functionality
      assert_respond_to(@gis, :radius)
      assert_nothing_raised{ @gis.radius }
      assert_kind_of(Float, @gis.radius)
   end

   def test_default_radius
      assert_equal(6367.45, @gis.radius)
   end

   def test_radius_expected_errors
      assert_raise(ArgumentError){ @gis.radius(1) }
   end

   def test_radius_setter_basic_functionality
      assert_respond_to(@gis, :radius=)
      assert_nothing_raised{ @gis.radius = 6368.0 }
      assert_equal(6368.0, @gis.radius)
   end

   def test_radius_setter_expected_errors
      assert_raise(GIS::Distance::Error){ @gis.radius = 6200 }
      assert_raise(GIS::Distance::Error){ @gis.radius = 6400 }
   end

   def test_formula_basic_functionality
      assert_respond_to(@gis, :formula)
      assert_nothing_raised{ @gis.formula }
      assert_kind_of(String, @gis.formula)
   end

   def test_formula
      assert_equal('haversine', @gis.formula)
   end

   def test_formula_setter_basic_functionality
      assert_respond_to(@gis, :formula=)
      assert_nothing_raised{ @gis.formula = 'haversine' }
   end

   def test_formula_expected_errors
      assert_raise(ArgumentError){ @gis.formula(1) }
      assert_raise(GIS::Distance::Error){ @gis.formula = 'foo' }
   end

   def test_mi_basic_functionality
      assert_respond_to(@gis.distance, :mi)
      assert_nothing_raised{ @gis.distance.mi }
      assert_kind_of(Float, @gis.distance.mi)
   end

   def test_mi
      assert(@gis.distance > @gis.distance.mi)
   end

   def test_mi_expected_errors
      assert_raise(ArgumentError){ @gis.distance.mi(1) }
   end

   def teardown
      @gis = nil
   end
end
