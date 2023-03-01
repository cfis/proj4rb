# encoding: UTF-8

require_relative './abstract_test'

class CoordinateSystemTest < AbstractTest
  def test_type
    crs = Proj::Crs.new('EPSG:4326')
    cs = crs.coordinate_system
    assert_equal(:PJ_CS_TYPE_ELLIPSOIDAL, cs.type)
  end

  def test_axis_count
    crs = Proj::Crs.new('EPSG:4326')
    cs = crs.coordinate_system
    assert_equal(2, cs.axis_count)
  end

  def test_axis_info
    crs = Proj::Crs.new('EPSG:4326')
    cs = crs.coordinate_system
    axis_info = cs.axis_info(0)

    assert_equal("Geodetic latitude", axis_info.name)
    assert_equal("Lat", axis_info.abbreviation)
    assert_equal("north", axis_info.direction)
    assert_equal(0.017453292519943295, axis_info.unit_conv_factor)
    assert_equal("degree", axis_info.unit_name)
    assert_equal("EPSG", axis_info.unit_auth_name)
    assert_equal("9122", axis_info.unit_code)
  end

  def test_axes
    crs = Proj::Crs.new('EPSG:4326')
    cs = crs.coordinate_system
    axes = cs.axes
    assert_equal(2, axes.count)

    axis_info = axes[0]
    assert_equal("Geodetic latitude", axis_info.name)
    assert_equal("Lat", axis_info.abbreviation)
    assert_equal("north", axis_info.direction)
    assert_equal(0.017453292519943295, axis_info.unit_conv_factor)
    assert_equal("degree", axis_info.unit_name)
    assert_equal("EPSG", axis_info.unit_auth_name)
    assert_equal("9122", axis_info.unit_code)

    axis_info = axes[1]
    assert_equal("Geodetic longitude", axis_info.name)
    assert_equal("Lon", axis_info.abbreviation)
    assert_equal("east", axis_info.direction)
    assert_equal(0.017453292519943295, axis_info.unit_conv_factor)
    assert_equal("degree", axis_info.unit_name)
    assert_equal("EPSG", axis_info.unit_auth_name)
    assert_equal("9122", axis_info.unit_code)
  end
end