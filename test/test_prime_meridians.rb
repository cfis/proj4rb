# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

if Proj4::LIBVERSION >= 449
  class PrimeMeridiansTest < Test::Unit::TestCase

    def test_get_all
      prime_meridians = Proj4::PrimeMeridian.list.sort.collect{ |u| u.id}
      assert prime_meridians.index('greenwich')
      assert prime_meridians.index('athens')
      assert prime_meridians.index('lisbon')
      assert prime_meridians.index('rome')
    end

    def test_one
      prime_meridian = Proj4::PrimeMeridian.get('lisbon')
      assert_kind_of Proj4::PrimeMeridian, prime_meridian
      assert_equal 'lisbon', prime_meridian.id
      assert_equal 'lisbon', prime_meridian.to_s
      assert_equal '9d07\'54.862"W', prime_meridian.defn
      assert_equal '#<Proj4::PrimeMeridian id="lisbon", defn="9d07\'54.862"W">', prime_meridian.inspect
    end

    def test_compare
      u1 = Proj4::PrimeMeridian.get('lisbon')
      u2 = Proj4::PrimeMeridian.get('lisbon')
      assert u1 == u2
    end

    def test_failed_get
      prime_meridian = Proj4::PrimeMeridian.get('foo')
      assert_nil prime_meridian
    end

    def test_new
      assert_raise TypeError do
        Proj4::PrimeMeridian.new
      end
    end

  end
end

