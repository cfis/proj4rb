# encoding: UTF-8

require_relative './abstract_test'

class UnitsTest < AbstractTest
  def test_get_all
    short_names = Proj::Unit.list.sort.collect {|unit| unit.proj_short_name}.compact
    assert(short_names.include?('deg'))
    assert(short_names.include?('km'))
    assert(short_names.include?('m'))
    assert(short_names.include?('yd'))
    assert(short_names.include?('us-mi'))
  end

  def test_linear_unit
    unit = Proj::Unit.list.find {|unit_info| unit_info.proj_short_name == 'km'}
    assert_kind_of Proj::Unit, unit
    assert_equal('kilometre', unit.name)
    assert_equal('kilometre', unit.to_s)
    assert_equal('km', unit.proj_short_name)
    assert_equal(1000.0, unit.conv_factor)
    assert_equal('EPSG', unit.auth_name)
    assert_equal('#<Proj::Unit authority="EPSG", code="9036", name="kilometre">', unit.inspect)
  end

  def test_angular_unit
    unit = Proj::Unit.list.find {|unit_info| unit_info.proj_short_name == 'deg'}
    assert_kind_of Proj::Unit, unit
    assert_equal('degree', unit.name)
    assert_equal('degree', unit.to_s)
    assert_equal('deg', unit.proj_short_name)
    assert_in_delta(0.01745, unit.conv_factor, 0.0001)
    assert_equal('EPSG', unit.auth_name)
    assert_equal('#<Proj::Unit authority="EPSG", code="9102", name="degree">', unit.inspect)
  end

  def test_compare
    unit_1 = Proj::Unit.list.find {|unit_info| unit_info.proj_short_name == 'km'}
    unit_2 = Proj::Unit.list.find {|unit_info| unit_info.proj_short_name == 'km'}
    assert(unit_1 == unit_2)
  end

  def test_failed_get
    unit = Proj::Unit.list.find {|unit_info| unit_info.proj_short_name == 'foo'}
    assert_nil unit
  end

  def test_category
    %w[linear linear_per_time angular angular_per_time scale scale_per_time time].each do |category|
      units = Proj::Unit.list(:category => category)
      refute_empty(units)
    end

    units = Proj::Unit.list(:category => 'foo')
    assert_empty(units)
  end

  def test_auth_name
    %w[EPSG PROJ].each do |auth_name|
      units = Proj::Unit.list(:auth_name => auth_name)
      refute_empty(units)
    end

    units = Proj::Unit.list(:auth_name => 'foo')
    assert_empty(units)
  end
end
