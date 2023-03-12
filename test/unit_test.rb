# encoding: UTF-8

require_relative './abstract_test'

class UnitsTest < AbstractTest
  def test_get_all
    database = Proj::Database.new(Proj::Context.current)
    units = database.units
    assert_equal(91, units.count)

    unit = units[0]
    assert_instance_of(Proj::Unit, unit)
  end

  def test_builtin
    units = Proj::Unit.built_in
    assert_equal(24, units.count)

    unit = units[0]
    assert_instance_of(Proj::Unit, unit)
  end

  def test_linear_unit
    database = Proj::Database.new(Proj::Context.current)
    units = database.units(category: "linear")
    assert_equal(52, units.count)

    unit = units[0]
    assert_instance_of(Proj::Unit, unit)
    assert_equal('millimetre', unit.name)
    assert_equal('millimetre', unit.to_s)
    assert_equal('mm', unit.proj_short_name)
    assert_equal(0.001, unit.conv_factor)
    assert_equal('EPSG', unit.auth_name)
    assert_equal('#<Proj::Unit authority="EPSG", code="1025", name="millimetre">', unit.inspect)
  end

  def test_angular_unit
    database = Proj::Database.new(Proj::Context.current)
    units = database.units(category: "angular")
    assert_equal(22, units.count)

    unit = units[0]
    assert_equal('milliarc-second', unit.name)
    assert_equal('milliarc-second', unit.to_s)
    refute(unit.proj_short_name)
    assert_in_delta(4.84813681109536e-09, unit.conv_factor, 0.0001)
    assert_equal('EPSG', unit.auth_name)
    assert_equal('#<Proj::Unit authority="EPSG", code="1031", name="milliarc-second">', unit.inspect)
  end

  def test_compare
    database = Proj::Database.new(Proj::Context.current)
    unit_1 = database.unit("EPSG", "9001")
    unit_2 = database.unit("EPSG", "9001")
    assert(unit_1 == unit_2)
  end

  def test_category
    database = Proj::Database.new(Proj::Context.current)

    %w[linear linear_per_time angular angular_per_time scale scale_per_time time].each do |category|
      units = database.units(category: category)
      refute_empty(units)
    end
  end

  def test_auth_name
    database = Proj::Database.new(Proj::Context.current)

    %w[EPSG PROJ].each do |auth_name|
      units = database.units(auth_name: auth_name)
      refute_empty(units)
    end
  end
end
