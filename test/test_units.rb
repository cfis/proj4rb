# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

if Proj4::LIBVERSION >= 449
  class UnitsTest < Test::Unit::TestCase

    def test_get_all
      units = Proj4::Unit.list.sort.collect{ |u| u.id }
      assert units.index('km')
      assert units.index('m')
      assert units.index('yd')
      assert units.index('us-mi')
    end

    def test_one
      unit = Proj4::Unit.get('km')
      assert_kind_of Proj4::Unit, unit
      assert_equal 'km', unit.id
      assert_equal 'km', unit.to_s
      assert_equal '1000.', unit.to_meter
      assert_equal 'Kilometer', unit.name
      assert_equal '#<Proj4::Unit id="km", to_meter="1000.", name="Kilometer">', unit.inspect
    end

    def test_compare
      u1 = Proj4::Unit.get('km')
      u2 = Proj4::Unit.get('km')
      assert u1 == u2
    end

    def test_failed_get
      unit = Proj4::Unit.get('foo')
      assert_nil unit
    end

    def test_new
      assert_raise TypeError do
        Proj4::Unit.new
      end
    end

  end
end

