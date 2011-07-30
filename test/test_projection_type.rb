# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

if Proj4::LIBVERSION >= 449
  class ProjectionTypesTest < Test::Unit::TestCase

    def test_get_all
      pt = Proj4::ProjectionType.list.sort.collect{ |u| u.id }
      assert pt.index('merc')
      assert pt.index('aea')
      assert pt.index('bipc')
    end

    def test_one
      pt = Proj4::ProjectionType.get('merc')
      assert_kind_of Proj4::ProjectionType, pt
      assert_equal 'merc', pt.id
      assert_equal 'merc', pt.to_s
      assert_equal 'Mercator', pt.name
      assert_equal "Mercator\n\tCyl, Sph&Ell\n\tlat_ts=", pt.descr
      assert_equal '#<Proj4::ProjectionType id="merc", name="Mercator">', pt.inspect
    end

    def test_compare
      pt1 = Proj4::ProjectionType.get('merc')
      pt2 = Proj4::ProjectionType.get('merc')
      assert pt1 == pt2
    end

    def test_failed_get
      assert_nil Proj4::ProjectionType.get('foo')
    end

    def test_new
      assert_raise TypeError do
        Proj4::ProjectionType.new
      end
    end

  end
end

