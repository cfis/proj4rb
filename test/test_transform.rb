$: << 'lib'
require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class TransformTest < Test::Unit::TestCase

    def setup
        @proj_wgs84 = Proj4::Projection.new(["init=epsg:4326"])
        @proj_gk    = Proj4::Projection.new(["init=epsg:31467"])
        @proj_merc  = Proj4::Projection.new(["proj=merc"])
        @lon =  8.4293092923
        @lat = 48.9896114523
        @rw = 3458305
        @hw = 5428192
        @zw = -5.1790915237
    end

    # echo "3458305 5428192" | cs2cs -f '%.10f' +init=epsg:31467 +to +init=epsg:4326 -
    def test_gk_to_wgs84
        point = @proj_gk.transform(@proj_wgs84, Proj4::Point.new(@rw, @hw, @zw))
        assert_in_delta @lon, point.x * Proj4::RAD_TO_DEG, 0.1 ** 9
        assert_in_delta @lat, point.y * Proj4::RAD_TO_DEG, 0.1 ** 9
        assert_in_delta 0, point.z, 0.1 ** 9
    end

    # echo "8.4293092923 48.9896114523" | cs2cs -f '%.10f' +init=epsg:4326 +to +init=epsg:31467 -
    def test_wgs84_to_gk
        point = @proj_wgs84.transform(@proj_gk, Proj4::Point.new(@lon * Proj4::DEG_TO_RAD, @lat * Proj4::DEG_TO_RAD, 0))
        assert_equal @rw, point.x.round
        assert_equal @hw, point.y.round
        assert_in_delta @zw, point.z, 0.1 ** 9
    end

    def test_no_dst_proj
        assert_raise TypeError do
            point = @proj_wgs84.transform(nil, Proj4::Point.new(@lon * Proj4::DEG_TO_RAD, @lat * Proj4::DEG_TO_RAD, 0))
        end
    end

    def test_not_a_point
        assert_raise TypeError do
            point = @proj_wgs84.transform(@proj_gk, nil)
        end
    end

    def test_mercator_at_pole
        assert_raise Proj4::Error do
            point = @proj_wgs84.transform(@proj_merc, Proj4::Point.new(0, 90 * Proj4::DEG_TO_RAD, 0))
        end
    end
end

