# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

if Proj4::LIBVERSION >= 449
  class EllipsoidsTest < Test::Unit::TestCase

    def test_get_all
      ellipsoids = Proj4::Ellipsoid.list.sort.collect{ |u| u.id }
      assert ellipsoids.index('WGS84')
      assert ellipsoids.index('bessel')
      assert ellipsoids.index('lerch')
    end

    def test_one
      ellipsoid = Proj4::Ellipsoid.get('bessel')
      assert_kind_of Proj4::Ellipsoid, ellipsoid
      assert_equal 'bessel', ellipsoid.id
      assert_equal 'a=6377397.155', ellipsoid.major
      assert_equal 'rf=299.1528128', ellipsoid.ell
      assert_equal 'Bessel 1841', ellipsoid.name
      assert_equal 'bessel', ellipsoid.to_s
      assert_equal '#<Proj4::Ellipsoid id="bessel", major="a=6377397.155", ell="rf=299.1528128", name="Bessel 1841">', ellipsoid.inspect
    end

    def test_compare
      e1 = Proj4::Ellipsoid.get('bessel')
      e2 = Proj4::Ellipsoid.get('bessel')
      assert e1 == e2
    end

    def test_failed_get
      ellipsoid = Proj4::Ellipsoid.get('foo')
      assert_nil ellipsoid
    end

    def test_new
      assert_raise TypeError do
        Proj4::Ellipsoid.new
      end
    end

  end
end

