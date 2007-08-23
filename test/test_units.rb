$: << 'lib'
require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class UnitsTest < Test::Unit::TestCase

    def test_get_all
        all_units = %w{km m dm cm mm kmi in ft yd mi fath ch link us-in us-ft us-yd us-ch us-mi ind-yd ind-ft ind-ch}.sort
        units = Proj4::Unit.listUnits.sort
        assert_equal all_units, units.collect{ |u| u.id }
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

    def test_failed_get
        unit = Proj4::Unit.get('foo')
        assert_nil unit
    end

end
