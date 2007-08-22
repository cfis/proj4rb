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
        rad * Proj4::RAD_TO_DEG
    end

    def deg2rad(deg)
        deg * Proj4::DEG_TO_RAD
    end

    def test_uv
        uv = Proj4::UV.new(10.1, 20.2)
        assert_kind_of Proj4::UV, uv
        assert_equal 10.1, uv.u
        assert_equal 20.2, uv.v
    end

    # echo "8.4302123334 48.9906726079" | proj +init=epsg:31467 -
    def test_forward_gk
        result = @proj_gk.forward( Proj4::UV.new( deg2rad(@lon), deg2rad(@lat) ) ) 
        assert_in_delta @rw, result.u, 0.1
        assert_in_delta @hw, result.v, 0.1
    end

    def test_forward_gk_degrees
        result = @proj_gk.forwardDeg( Proj4::UV.new( @lon, @lat ) ) 
        assert_in_delta @rw, result.u, 0.1
        assert_in_delta @hw, result.v, 0.1
    end

    # echo "3458305 5428192" | invproj -f '%.10f' +init=epsg:31467 -
    def test_inverse_gk
        result = @proj_gk.inverse( Proj4::UV.new(@rw, @hw) ) 
        assert_in_delta @lon, rad2deg(result.u), 0.000000001
        assert_in_delta @lat, rad2deg(result.v), 0.000000001
    end

    def test_inverse_gk_degrees
        result = @proj_gk.inverseDeg( Proj4::UV.new(@rw, @hw) ) 
        assert_in_delta @lon, result.u, 0.000000001
        assert_in_delta @lat, result.v, 0.000000001
    end

    # echo "190 92" | proj +init=epsg:31467 -
    def test_out_of_bounds
        result = @proj_gk.forward( Proj4::UV.new( deg2rad(190), deg2rad(92) ) ) 
        assert_equal 'Infinity', result.u.to_s
        assert_equal 'Infinity', result.v.to_s
    end

end

