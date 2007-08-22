$: << 'lib'
require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class CreateProjectionTest < Test::Unit::TestCase

    def setup
        @proj_wgs84   = Proj4::Projection.new(["init=epsg:4326"])     # WGS84
        @proj_gk      = Proj4::Projection.new(["init=epsg:31467"])    # Gauss-Kruger Zone 3
        @proj_conakry = Proj4::Projection.new(["init=epsg:31528"])    # Conakry 1905 / UTM zone 28N
    end

    def test_is_latlong
        assert   @proj_wgs84.isLatLong?
        assert ! @proj_gk.isLatLong?
        assert ! @proj_conakry.isLatLong?
    end

    def test_is_geocent
        assert_equal @proj_gk.isGeocent?, @proj_gk.isGeocentric?    # two names for same method
        assert ! @proj_gk.isGeocent?
        assert ! @proj_wgs84.isGeocent?
        assert ! @proj_conakry.isGeocent?
    end

end

