# encoding: UTF-8

require_relative './abstract_test'

class UnitsTest < AbstractTest
  def test_get_all
    units = Proj::Unit.list.sort.collect {|unit| unit.id}
    assert(units.include?('deg'))
    assert(units.include?('km'))
    assert(units.include?('m'))
    assert(units.include?('yd'))
    assert(units.include?('us-mi'))
  end

  def test_linear_unit
    unit = Proj::Unit.get('km')
    assert_kind_of Proj::Unit, unit
    assert_equal('km', unit.id)
    assert_equal('km', unit.to_s)
    assert_equal('1000', unit.to_meter)
    assert_equal(1000.0, unit.factor)
    assert_equal('Kilometer', unit.name)
    assert_equal('#<Proj::Unit id="km", to_meter="1000", factor="1000.0", name="Kilometer">', unit.inspect)
  end

  def test_angular_unit
    unit = Proj::Unit.get('deg')
    assert_kind_of Proj::Unit, unit
    assert_equal('deg', unit.id)
    assert_equal('deg', unit.to_s)
    assert_equal('0.017453292519943296', unit.to_meter)
    assert_equal(0.017453292519943295, unit.factor)
    assert_equal('Degree', unit.name)
    assert_equal('#<Proj::Unit id="deg", to_meter="0.017453292519943296", factor="0.017453292519943295", name="Degree">', unit.inspect)
  end

  def test_compare
    u1 = Proj::Unit.get('km')
    u2 = Proj::Unit.get('km')
    assert(u1 == u2)
  end

  def test_failed_get
    unit = Proj::Unit.get('foo')
    assert_nil unit
  end
end
