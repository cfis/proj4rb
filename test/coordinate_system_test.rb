# encoding: UTF-8

require_relative './abstract_test'

class CoordinateSystemTest < AbstractTest
  def test_create
    context = Proj::Context.new
    crs = Proj::Crs.new('EPSG:4326', context)
    cs = crs.coordinate_system
    axes = cs.axes
    cs = Proj::CoordinateSystem.create(cs.type, axes, context)
    assert_equal(2, cs.axis_count)
    assert_equal(:PJ_CS_TYPE_ELLIPSOIDAL, cs.type)
    assert_equal(:PJ_TYPE_UNKNOWN, cs.proj_type)
    refute(cs.auth_name)
    refute(cs.id_code)
  end

  def test_create_ellipsoidal_2d
    context = Proj::Context.new
    cs = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LONGITUDE_LATITUDE, context)
    assert_equal(2, cs.axis_count)
    assert_equal(:PJ_CS_TYPE_ELLIPSOIDAL, cs.type)
    assert_equal(:PJ_TYPE_UNKNOWN, cs.proj_type)
    refute(cs.auth_name)
    refute(cs.id_code)
  end

  def test_create_ellipsoidal_3d
    context = Proj::Context.new
    cs = Proj::CoordinateSystem.create_ellipsoidal_3d(:PJ_ELLPS3D_LATITUDE_LONGITUDE_HEIGHT, context)
    assert_equal(3, cs.axis_count)
    assert_equal(:PJ_CS_TYPE_ELLIPSOIDAL, cs.type)
    assert_equal(:PJ_TYPE_UNKNOWN, cs.proj_type)

    axis = cs.axis_info(0)
    assert_equal("Latitude", axis.name)
    assert_equal("lat", axis.abbreviation)
    assert_equal("north", axis.direction)
    assert_equal("degree", axis.unit_name)
    assert_in_delta(0.017453292519943295, axis.unit_conv_factor)

    axis = cs.axis_info(1)
    assert_equal("Longitude", axis.name)
    assert_equal("lon", axis.abbreviation)
    assert_equal("east", axis.direction)
    assert_equal("degree", axis.unit_name)
    assert_in_delta(0.017453292519943295, axis.unit_conv_factor)
  end

  def test_create_ellipsoidal_3d_custom_units
    context = Proj::Context.new
    cs = Proj::CoordinateSystem.create_ellipsoidal_3d(:PJ_ELLPS3D_LATITUDE_LONGITUDE_HEIGHT, context,
                                                      horizontal_angular_unit_name: "foo", horizontal_angular_unit_conv_factor: 0.5,
                                                      vertical_linear_unit_name: "bar", vertical_linear_unit_conv_factor: 0.6)
    assert_equal(3, cs.axis_count)
    assert_equal(:PJ_CS_TYPE_ELLIPSOIDAL, cs.type)
    assert_equal(:PJ_TYPE_UNKNOWN, cs.proj_type)

    axis = cs.axis_info(0)
    assert_equal("Latitude", axis.name)
    assert_equal("lat", axis.abbreviation)
    assert_equal("north", axis.direction)
    assert_equal("foo", axis.unit_name)
    assert_equal(0.5, axis.unit_conv_factor)

    axis = cs.axis_info(1)
    assert_equal("Longitude", axis.name)
    assert_equal("lon", axis.abbreviation)
    assert_equal("east", axis.direction)
    assert_equal("foo", axis.unit_name)
    assert_equal(0.5, axis.unit_conv_factor)

    axis = cs.axis_info(2)
    assert_equal("Ellipsoidal height", axis.name)
    assert_equal("h", axis.abbreviation)
    assert_equal("up", axis.direction)
    assert_equal("bar", axis.unit_name)
    assert_equal(0.6, axis.unit_conv_factor)
  end

  def test_create_cartesian
    context = Proj::Context.new
    coordinate_system = Proj::CoordinateSystem.create_cartesian_2d(context, :PJ_CART2D_EASTING_NORTHING)
    assert_equal(2, coordinate_system.axis_count)
    assert_equal(:PJ_CS_TYPE_CARTESIAN, coordinate_system.type)
    assert_equal(:PJ_TYPE_UNKNOWN, coordinate_system.proj_type)
  end

  def test_type
    crs = Proj::Crs.new('EPSG:4326')
    cs = crs.coordinate_system
    refute(cs.name)
    assert_equal(:PJ_CS_TYPE_ELLIPSOIDAL, cs.type)
    assert_equal(:PJ_TYPE_UNKNOWN, cs.proj_type)
    assert_equal("EPSG", cs.auth_name)
    assert_equal("6422", cs.id_code)
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