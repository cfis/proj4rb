# encoding: UTF-8

require_relative './abstract_test'
class PjObjectTest < AbstractTest
  def test_clone
    object = Proj::PjObject.create("+proj=longlat")
    clone = object.clone
    assert(object.equivalent_to?(clone, :PJ_COMP_STRICT))
    assert(object.context.equal?(clone.context))
  end

  def test_dup
    object = Proj::PjObject.create("+proj=longlat")
    clone = object.dup
    assert(object.equivalent_to?(clone, :PJ_COMP_STRICT))
    assert(object.context.equal?(clone.context))
  end
  
  def test_equivalent
    from_epsg = Proj::PjObject.create_from_database("EPSG", "7844", :PJ_CATEGORY_CRS)
    from_wkt = Proj::PjObject.create_from_wkt(<<~EOS)
                    GEOGCRS["GDA2020",
                      DATUM["GDA2020",
                          ELLIPSOID["GRS_1980",6378137,298.257222101,
                              LENGTHUNIT["metre",1]]],
                      PRIMEM["Greenwich",0,
                          ANGLEUNIT["Degree",0.0174532925199433]],
                      CS[ellipsoidal,2],
                          AXIS["geodetic latitude (Lat)",north,
                              ORDER[1],
                              ANGLEUNIT["degree",0.0174532925199433]],
                          AXIS["geodetic longitude (Lon)",east,
                              ORDER[2],
                              ANGLEUNIT["degree",0.0174532925199433]]]"
                  EOS

    assert(from_epsg.equivalent_to?(from_wkt, :PJ_COMP_EQUIVALENT))
  end

  def test_accuracy_crs
    object = Proj::PjObject.create_from_database("EPSG", "4326", :PJ_CATEGORY_CRS)
    assert_equal(-1, object.accuracy)
  end

  def test_accuracy_coordinate_operation
    object = Proj::PjObject.create_from_database("EPSG", "1170", :PJ_CATEGORY_COORDINATE_OPERATION)
    assert_equal(16.0, object.accuracy)
  end

  def test_accuracy_projection
    object = Proj::Conversion.new("+proj=helmert")
    assert_equal(-1.0, object.accuracy)
  end

  def test_id_code
    crs = Proj::Crs.new('EPSG:4326')
    assert_equal("4326", crs.id_code)
    refute(crs.id_code(1))
  end

  def test_remarks_transformation
    transformation = Proj::PjObject.create_from_database("EPSG", "8048", :PJ_CATEGORY_COORDINATE_OPERATION)

    expected = "Scale difference in ppb where 1/billion = 1E-9. See CT codes 8444-46 for NTv2 method giving equivalent results for Christmas Island, Cocos Islands and Australia respectively. See CT code 8447 for alternative including distortion model for Australia only."
    assert_equal(expected, transformation.remarks)
  end

  def test_remarks_conversion
    operation = Proj::PjObject.create_from_database("EPSG", "3811", :PJ_CATEGORY_COORDINATE_OPERATION)

    expected = "Replaces Lambert 2005."
    assert_equal(expected, operation.remarks)
  end

  def test_scope_transformation
    transformation = Proj::PjObject.create_from_database("EPSG", "8048", :PJ_CATEGORY_COORDINATE_OPERATION)

    expected = "Transformation of GDA94 coordinates that have been derived through GNSS CORS."
    assert_equal(expected, transformation.scope)
  end

  def test_scope_conversion
    operation = Proj::PjObject.create_from_database("EPSG", "3811", :PJ_CATEGORY_COORDINATE_OPERATION)

    expected = "Engineering survey, topographic mapping."
    assert_equal(expected, operation.scope)
  end

  def test_scope_invalid
    operation = Proj::Conversion.new("+proj=noop")
    refute(operation.scope)
  end

  def test_factors
    conversion = Proj::Conversion.new("+proj=merc +ellps=WGS84")
    coord = Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(55))
    factors = conversion.factors(coord)

    assert_in_delta(1.739526610076288, factors[:meridional_scale], 1e-7)
    assert_in_delta(1.739526609938368, factors[:parallel_scale], 1e-7)
    assert_in_delta(3.0259528269235867, factors[:areal_scale], 1e-7)

    assert_in_delta(0.0, factors[:angular_distortion], 1e-7)
    assert_in_delta(1.5707963267948966, factors[:meridian_parallel_angle], 1e-7)
    assert_in_delta(0.0, factors[:meridian_convergence], 1e-7)

    assert_in_delta(1.7395266100073281, factors[:tissot_semimajor], 1e-7)
    assert_in_delta(1.7395266100073281, factors[:tissot_semiminor], 1e-7)

    assert_in_delta(0.9999999999996122, factors[:dx_dlam], 1e-7)
    assert_in_delta(0.0, factors[:dx_dphi], 1e-7)
    assert_in_delta(0.0, factors[:dy_dlam], 1e-7)
    assert_in_delta(1.7395897312200146, factors[:dy_dphi], 1e-7)
  end

  def test_create_from_name
    context = Proj::Context.new
    objects = Proj::PjObject.create_from_name("WGS 84", context)
    assert_equal(5, objects.size)
  end

  def test_create_from_name_with_auth_name
    context = Proj::Context.new
    objects = Proj::PjObject.create_from_name("WGS 84", context, auth_name: "xx")
    assert_equal(0, objects.size)
  end

  def test_create_from_name_with_types
    context = Proj::Context.new
    objects = Proj::PjObject.create_from_name("WGS 84", context, types: [:PJ_TYPE_GEODETIC_CRS, :PJ_TYPE_PROJECTED_CRS])
    assert_equal(3, objects.size)
  end

  def test_create_from_name_with_types_and_approximate_match
    context = Proj::Context.new
    objects = Proj::PjObject.create_from_name("WGS 84", context, approximate_match: true,
                                              types: [:PJ_TYPE_GEODETIC_CRS, :PJ_TYPE_PROJECTED_CRS])

    expected = proj9? ? 442 : 440
    assert_equal(expected, objects.size)
  end

  def test_create_from_name_with_types_and_approximate_match_and_limit
    context = Proj::Context.new
    objects = Proj::PjObject.create_from_name("WGS 84", context, approximate_match: true, limit: 25,
                                              types: [:PJ_TYPE_GEODETIC_CRS, :PJ_TYPE_PROJECTED_CRS])
    assert_equal(25, objects.size)
  end

  def test_deprecated_true
    wkt = <<~EOS
          GEOGCRS["SAD69 (deprecated)",
              DATUM["South_American_Datum_1969",
                  ELLIPSOID["GRS 1967",6378160,298.247167427,
                      LENGTHUNIT["metre",1,
                          ID["EPSG",9001]]]],
              PRIMEM["Greenwich",0,
                  ANGLEUNIT["degree",0.0174532925199433,
                      ID["EPSG",9122]]],
              CS[ellipsoidal,2],
                  AXIS["latitude",north,
                      ORDER[1],
                      ANGLEUNIT["degree",0.0174532925199433,
                          ID["EPSG",9122]]],
                  AXIS["longitude",east,
                      ORDER[2],
                      ANGLEUNIT["degree",0.0174532925199433,
                          ID["EPSG",9122]]]]
    EOS

    crs = Proj::Crs.create(wkt)
    assert(crs.deprecated?)
  end

  def test_deprecated_false
    crs = Proj::Crs.create_from_database("EPSG", "4326", :PJ_CATEGORY_CRS)
    refute(crs.deprecated?)
  end
end
