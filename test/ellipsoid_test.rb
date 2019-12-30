# encoding: UTF-8

require_relative './abstract_test'

class EllipsoidTest < AbstractTest
  def test_get_all
    ellipsoids = Proj::Ellipsoid.list.map {|ellipsoid| ellipsoid.id }
    assert(ellipsoids.include?('WGS84'))
    assert(ellipsoids.include?('bessel'))
    assert(ellipsoids.include?('lerch'))
  end

  def test_one
    ellipsoid = Proj::Ellipsoid.get('bessel')
    assert_kind_of Proj::Ellipsoid, ellipsoid
    assert_equal('bessel', ellipsoid.id)
    assert_equal('a=6377397.155', ellipsoid.major)
    assert_equal('rf=299.1528128', ellipsoid.ell)
    assert_equal('Bessel 1841', ellipsoid.name)
    assert_equal('bessel', ellipsoid.to_s)
    assert_equal('#<Proj::Ellipsoid id="bessel", major="a=6377397.155", ell="rf=299.1528128", name="Bessel 1841">', ellipsoid.inspect)
  end

  def test_equal
    e1 = Proj::Ellipsoid.get('bessel')
    e2 = Proj::Ellipsoid.get('bessel')
    assert e1 == e2
  end

  def test_failed_get
    ellipsoid = Proj::Ellipsoid.get('foo')
    assert_nil ellipsoid
  end
end
