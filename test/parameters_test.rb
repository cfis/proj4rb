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

  def test_bbox_valid
    params = Proj::Parameters.new
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
end