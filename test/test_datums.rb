# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

if Proj4::LIBVERSION >= 449
  class DatumsTest < Test::Unit::TestCase

    def test_get_all
      datums = Proj4::Datum.list.sort.collect{ |u| u.id }
      assert datums.index('WGS84')
      assert datums.index('potsdam')
      assert datums.index('ire65')
    end

    def test_one
      datum = Proj4::Datum.get('potsdam')
      assert_kind_of Proj4::Datum, datum
      assert_equal 'potsdam', datum.id
      assert_equal 'potsdam', datum.to_s
      assert_equal 'bessel', datum.ellipse_id
      assert_equal 'towgs84=606.0,23.0,413.0', datum.defn
      assert_equal 'Potsdam Rauenberg 1950 DHDN', datum.comments
      assert_equal '#<Proj4::Datum id="potsdam", ellipse_id="bessel", defn="towgs84=606.0,23.0,413.0", comments="Potsdam Rauenberg 1950 DHDN">', datum.inspect
    end

    def test_compare
      u1 = Proj4::Datum.get('potsdam')
      u2 = Proj4::Datum.get('potsdam')
      assert u1 == u2
    end

    def test_failed_get
      datum = Proj4::Datum.get('foo')
      assert_nil datum
    end

    def test_new
      assert_raise TypeError do
        Proj4::Datum.new
      end
    end

  end
end
