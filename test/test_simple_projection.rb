$: << 'lib'
require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class SimpleProjectionTest < Test::Unit::TestCase

    def setup
        @proj_gk = Proj4::Projection.new(["init=epsg:31467"])
        @lon =  8.4302123334
        @lat = 48.9906726079
        @rw = 3458305
        @hw = 5428192
    end

    def rad2deg(rad)
        rad * 180 / Math::PI
    end

    def deg2rad(deg)
        deg * Math::PI / 180
    end

    # echo "8.4302123334 48.9906726079" | proj +init=epsg:31467 -
    def test_forward_gk
        result = @proj_gk.forward( Proj4::UV.new( deg2rad(@lon), deg2rad(@lat) ) ) 
        assert_in_delta @rw, result.u, 0.1
        assert_in_delta @hw, result.v, 0.1
    end

    # echo "3458305 5428192" | invproj -f '%.10f' +init=epsg:31467 -
    def test_inverse_gk
        result = @proj_gk.inverse( Proj4::UV.new(@rw, @hw) ) 
        assert_in_delta @lon, rad2deg(result.u), 0.000000001
        assert_in_delta @lat, rad2deg(result.v), 0.000000001
    end

end

