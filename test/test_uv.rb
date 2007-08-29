$: << 'lib'
require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

# this is needed to get rid of the "UV is deprecated" warnings
$VERBOSE = nil

class UVTest < Test::Unit::TestCase

    def test_create_set_get
        uv = Proj4::UV.new(10.1, 20.2)
        assert_kind_of Proj4::UV, uv
        assert_equal 10.1, uv.u
        assert_equal 20.2, uv.v
        uv.u = 30.3
        assert_equal 30.3, uv.u
        uv.v = 40.4
        assert_equal 40.4, uv.v
    end

    def test_copy
        uv1 = Proj4::UV.new(10.1, 20.2)
        uv2 = uv1.dup
        assert_equal uv1, uv2
        uv3 = uv1.clone
        assert_equal uv1, uv3
    end

    def test_failed_creation
        assert_raise ArgumentError do
            Proj4::UV.new(1)
        end
        assert_raise ArgumentError do
            Proj4::UV.new(1, 2, 3)
        end
        assert_raise TypeError do
            Proj4::UV.new('foo', 'bar')
        end
    end

    def test_equality
        uv1 = Proj4::UV.new(10.1, 20.2)
        uv2 = Proj4::UV.new(10.1, 20.2)
        assert_equal uv1, uv2
    end

    def test_stringify
        uv = Proj4::UV.new(10.1, 20.2)
        assert_equal '10.1,20.2', uv.to_s
    end

end

