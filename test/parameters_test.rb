# encoding: UTF-8

require_relative './abstract_test'

class ParametersTest < AbstractTest
  def test_types_nil
    params = Proj::Parameters.new
    assert(params.types.empty?)
  end

  def test_types_one
    types = [:PJ_TYPE_GEODETIC_CRS]
    params = Proj::Parameters.new
    params.types = types
    assert_equal(types, params.types)
  end

  def test_types_many
    types = [:PJ_TYPE_GEODETIC_CRS, :PJ_TYPE_GEOCENTRIC_CRS, :PJ_TYPE_GEOGRAPHIC_CRS]
    params = Proj::Parameters.new
    params.types = types
    assert_equal(types, params.types)
  end

  def test_to_description_unit_name
    param = Proj::Parameter.new(name: "Latitude of natural origin",
                                value: 0.0,
                                unit_conv_factor: 0.0174532925199433,
                                unit_name: "degree",
                                unit_type: :PJ_UT_ANGULAR)
    desc = param.to_description
    assert_equal("degree", desc[:unit_name])
  end

  def test_types_buffer_is_retained
    params = Proj::Parameters.new
    params.types = [:PJ_TYPE_GEODETIC_CRS]

    # The buffer assigned into the native struct must be strongly referenced
    # on the Ruby side to avoid dangling pointers after GC.
    assert_instance_of(FFI::MemoryPointer, params.instance_variable_get(:@types_ptr))
  end

  def test_bbox_valid
    params = Proj::Parameters.new

    params.bbox_valid = false
    refute(params.bbox_valid)

    params.bbox_valid = true
    assert(params.bbox_valid)
  end

  def test_allow_deprecated
    params = Proj::Parameters.new
    refute(params.allow_deprecated)

    params.allow_deprecated = true
    assert(params.allow_deprecated)
  end

  def test_bbox_coordinates
    params = Proj::Parameters.new
    params.west_lon_degree = -120.0
    params.south_lat_degree = 40.0
    params.east_lon_degree = -80.0
    params.north_lat_degree = 64.0

    assert_equal(-120.0, params.west_lon_degree)
    assert_equal(40.0, params.south_lat_degree)
    assert_equal(-80.0, params.east_lon_degree)
    assert_equal(64.0, params.north_lat_degree)
  end

  def test_crs_area_of_use_contains_bbox
    params = Proj::Parameters.new
    params.crs_area_of_use_contains_bbox = 1
    assert_equal(1, params.crs_area_of_use_contains_bbox)
  end

  def test_celestial_body_name
    params = Proj::Parameters.new
    params.celestial_body_name = "Earth"
    assert_equal("Earth", params.celestial_body_name)
  end
end
