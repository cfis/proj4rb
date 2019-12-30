# encoding: UTF-8

require_relative './abstract_test'

class PrimeMeridiansTest < AbstractTest
  def test_get_all
    prime_meridians = Proj::PrimeMeridian.list.sort.collect {|prime_meridian| prime_meridian.id}
    assert prime_meridians.index('greenwich')
    assert prime_meridians.index('athens')
    assert prime_meridians.index('lisbon')
    assert prime_meridians.index('rome')
  end

  def test_one
    prime_meridian = Proj::PrimeMeridian.get('lisbon')
    assert_kind_of(Proj::PrimeMeridian, prime_meridian)
    assert_equal('lisbon', prime_meridian.id)
    assert_equal('9d07\'54.862"W', prime_meridian.defn)
    assert_equal('#<Proj::PrimeMeridian id="lisbon", defn="9d07\'54.862"W">', prime_meridian.inspect)
  end

  def test_compare
    u1 = Proj::PrimeMeridian.get('lisbon')
    u2 = Proj::PrimeMeridian.get('lisbon')
    assert u1 == u2
  end

  def test_failed_get
    prime_meridian = Proj::PrimeMeridian.get('foo')
    assert_nil prime_meridian
  end
end

