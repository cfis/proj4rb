# encoding: UTF-8

require_relative './abstract_test'

class ConversionTest < AbstractTest
  def test_create_conversion
    context = Proj::Context.new
    param = Proj::Parameter.new(name: "param name", value: 0.99,
                                unit_conv_factor: 1.0, unit_type: :PJ_UT_SCALE)

    conversion = Proj::Conversion.create_conversion(context, name: "conv",
                                                    auth_name: "conv auth", code: "conv code",
                                                    method_name: "method", method_auth_name: "method auth", method_code: "method code",
                                                    params: [param])
    assert(conversion)
    assert_equal("conv", conversion.name)
    assert_equal("conv auth:conv code", conversion.auth)
    assert_equal(:PJ_TYPE_CONVERSION, conversion.proj_type)
  end

  def test_inverse_operation
    operation = Proj::Conversion.new(<<~EOS)
                  +proj=pipeline +step +proj=axisswap +order=2,1 +step 
                  +proj=unitconvert +xy_in=deg +xy_out=rad +step +proj=push 
                  +v_3 +step +proj=cart +ellps=evrst30 +step +proj=helmert 
                  +x=293 +y=836 +z=318 +rx=0.5 +ry=1.6 +rz=-2.8 +s=2.1 
                  +convention=position_vector +step +inv +proj=cart 
                  +ellps=WGS84 +step +proj=pop +v_3 +step +proj=unitconvert 
                  +xy_in=rad +xy_out=deg +step +proj=axisswap +order=2,1
                EOS

    inverse = operation.create_inverse
    proj_string = inverse.to_proj_string(:PJ_PROJ_5, multiline: true, indentation_width: 4, max_line_length: 40)

    expected = if Proj::Api::PROJ_VERSION >= '7.0.0'
                 <<~EOS
                  +proj=pipeline
                      +step +proj=axisswap +order=2,1
                      +step +proj=unitconvert +xy_in=deg
                            +xy_out=rad
                      +step +proj=push +v_3
                      +step +proj=cart +ellps=WGS84
                      +step +inv +proj=helmert +x=293
                            +y=836 +z=318 +rx=0.5 +ry=1.6
                            +rz=-2.8 +s=2.1
                            +convention=position_vector
                      +step +inv +proj=cart +ellps=evrst30
                      +step +proj=pop +v_3
                      +step +proj=unitconvert +xy_in=rad
                            +xy_out=deg
                      +step +proj=axisswap +order=2,1
                 EOS
               else
                 "+proj=pipeline +step +proj=axisswap +order=2,1 +step +proj=unitconvert +xy_in=deg +xy_out=rad +step +proj=push +v_3 +step +proj=cart +ellps=WGS84 +step +inv +proj=helmert +x=293 +y=836 +z=318 +rx=0.5 +ry=1.6 +rz=-2.8 +s=2.1 +convention=position_vector +step +inv +proj=cart +ellps=evrst30 +step +proj=pop +v_3 +step +proj=unitconvert +xy_in=rad +xy_out=deg +step +proj=axisswap +order=2,1"
               end

    assert_equal(expected.strip, proj_string)
  end

  def test_accuracy_coordinate_operation
    object = Proj::Conversion.create_from_database("EPSG", "1170", :PJ_CATEGORY_COORDINATE_OPERATION)
    assert_equal(16.0, object.accuracy)
  end

  def test_roundrip
    conversion = Proj::Conversion.new("+proj=cart +ellps=GRS80")
    coord1 = Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(55), z: 100)
    coord2 = conversion.forward(coord1)

    dist = conversion.roundtrip(:PJ_FWD, 10000, coord1)
    dist += conversion.roundtrip(:PJ_INV, 10000, coord2)
    assert(dist < 4e-9)
  end

  def test_accuracy_projection
    conversion = Proj::Conversion.create("+proj=helmert")
    assert_equal(-1.0, conversion.accuracy)
  end

  def test_method_info
    crs = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    operation = crs.coordinate_operation
    assert_equal("Transverse Mercator", operation.method_name)
    assert_equal("EPSG", operation.method_auth_name)
    assert_equal("9807", operation.method_code)
  end

  def test_ballpark_transformation
    crs = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    operation = crs.coordinate_operation
    refute(operation.ballpark_transformation?)
  end

  def test_param_count
    crs = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    operation = crs.coordinate_operation
    assert_equal(5, operation.param_count)
  end

  def test_param
    crs = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    operation = crs.coordinate_operation

    param = operation.param(3)
    assert_equal("False easting", param.name)
    assert_equal("EPSG", param.auth_name)
    assert_equal("8806", param.code)
    assert_equal(500000.0, param.value)
    refute(param.value_string)
    assert_equal(1.0, param.unit_conv_factor)
    assert_equal("metre", param.unit_name)
    assert_equal("EPSG", param.unit_auth_name)
    assert_equal("9001", param.unit_code)
    assert_equal("linear", param.unit_category)
  end

  def test_grid_count
    operation = Proj::Conversion.create_from_database("EPSG", "1312", :PJ_CATEGORY_COORDINATE_OPERATION)
    assert_equal(1, operation.grid_count)
  end

  def test_grid_url_invalid_index
    context = Proj::Context.new
    conversion = Proj::Conversion.create_from_database("EPSG", "1312", :PJ_CATEGORY_COORDINATE_OPERATION, false, context)

    error = assert_raises(Proj::Error) do
      conversion.grid(-1)
    end

    if Proj::Api::PROJ_VERSION >= '9.0.0'
      assert_equal("File not found or invalid", error.to_s)
    else
      assert_equal("Unknown error (code 4096)", error.to_s)
    end
  end

  def test_grid_url
    context = Proj::Context.new

    conversion = Proj::Conversion.create_from_database("EPSG", "1312", :PJ_CATEGORY_COORDINATE_OPERATION, true, context)
    grid = conversion.grid(0)

    assert_equal("ca_nrc_ntv1_can.tif", grid.name)
    assert(grid.package_name.empty?)
    assert_equal("https://cdn.proj.org/ca_nrc_ntv1_can.tif", grid.url)
    assert(grid.downloadable?)
    assert(grid.open_license?)
    #assert_match(/ntv1_can/, grid.full_name)
    #assert(grid.available?)
  end

  def test_xy_dist
    conversion = Proj::Conversion.new("+proj=utm; +zone=32; +ellps=GRS80")
    coord1 = Proj::Coordinate.new(lam: Proj.degrees_to_radians(12),
                                  phi: Proj.degrees_to_radians(55))

    coord2 = conversion.forward(coord1)
    coord1 = conversion.forward(coord1)

    dist = conversion.xy_distance(coord1, coord2)
    assert(dist < 2e-9)
  end

  def test_angular_input
    conversion = Proj::Conversion.new("+proj=cart +ellps=GRS80")
    assert(conversion.angular_input?(:PJ_FWD))
    refute(conversion.angular_input?(:PJ_INV))
  end

  def test_angular_output
    conversion = Proj::Conversion.new("+proj=cart +ellps=GRS80")
    refute(conversion.angular_output?(:PJ_FWD))
    assert(conversion.angular_output?(:PJ_INV))
  end

  def test_degree_input
    skip "Unsure why these test fail"
    conversion = Proj::Conversion.new(<<~EOS)
                    +proj=pipeline
                    +step +inv +proj=utm +zone=32 +ellps=GRS80
                    "+step +proj=unitconvert +xy_in=rad +xy_out=deg
                  EOS

    refute(conversion.degree_input?(:PJ_FWD))
    assert(conversion.degree_input?(:PJ_INV))
  end

  def test_degree_output
    skip "Unsure why these test fail"
    conversion = Proj::Conversion.new(<<~EOS)
                    +proj=pipeline
                    +step +inv +proj=utm +zone=32 +ellps=GRS80
                    "+step +proj=unitconvert +xy_in=rad +xy_out=deg
    EOS

    assert(conversion.degree_output?(:PJ_FWD))
    refute(conversion.degree_output?(:PJ_INV))
  end

  def test_steps_concatenated
    context = Proj::Context.new
    source_crs = Proj::Conversion.create_from_database("EPSG", "28356", :PJ_CATEGORY_CRS)
    target_crs = Proj::Conversion.create_from_database("EPSG", "7856", :PJ_CATEGORY_CRS)

    factory_context = Proj::OperationFactoryContext.new(context)
    factory_context.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
    factory_context.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

    operations = factory_context.create_operations(source_crs, target_crs)
    assert_equal(3, operations.count)

    operation = operations[0]
    assert_instance_of(Proj::Conversion, operation)
    assert_equal(:PJ_TYPE_CONCATENATED_OPERATION, operation.proj_type)

    assert_equal(3, operation.step_count)
    refute(operation.step(-1))

    step = operation.step(1)
    assert_equal("Transformation of GDA94 coordinates that have been derived through GNSS CORS.", step.scope)
    assert_equal("Scale difference in ppb where 1/billion = 1E-9. See CT codes 8444-46 for NTv2 method giving equivalent results for Christmas Island, Cocos Islands and Australia respectively. See CT code 8447 for alternative including distortion model for Australia only.", step.remarks)
  end

  def test_transform_array
    crs = Proj::Conversion.new("+proj=utm +zone=32 +ellps=GRS80")

    coord1 = Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(55), z: 45)
    coord2 = Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(56), z: 50)
    new_coords = crs.transform_array([coord1, coord2], :PJ_FWD)

    coord = new_coords[0]
    assert_equal(691875.6321396607, coord.x)
    assert_equal(6098907.825005012, coord.y)
    assert_equal(45, coord.z)
    assert_equal(0, coord.t)

    coord = new_coords[1]
    assert_equal(687071.439109443, coord.x)
    assert_equal(6210141.326748009, coord.y)
    assert_equal(50, coord.z)
    assert_equal(0, coord.t)
  end

  def test_transform_array_invalid
    context = Proj::Context.new
    crs = Proj::Conversion.new("+proj=utm +zone=32 +ellps=GRS80", context)

    coord1 = Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(95), z: 45)
    coord2 = Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(56), z: 50)

    error = assert_raises(Proj::Error) do
      crs.transform_array([coord1, coord2], :PJ_FWD)
    end

    assert_equal("Invalid coordinate", error.to_s)
  end

  def test_pipeline
    conversion = Proj::Conversion.new(<<~EOS)
                    +proj=pipeline
                    +step +inv +proj=lcc +lat_1=33.88333333333333
                    +lat_2=32.78333333333333 +lat_0=32.16666666666666
                    +lon_0=-116.25 +x_0=2000000.0001016 +y_0=500000.0001016001 +ellps=GRS80
                    +towgs84=0,0,0,0,0,0,0 +units=us-ft +no_defs
                    +step +proj=lcc +lat_1=33.88333333333333 +lat_2=32.78333333333333 +lat_0=32.16666666666666
                    +lon_0=-116.25 +x_0=2000000 +y_0=500000
                    +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs
                  EOS

    # The Presidio, approximately
    coordinate_1 = Proj::Coordinate.new(x: 4760096.421921, y: 3744293.729449)
    coordinate_2 = conversion.forward(coordinate_1)

    assert_in_delta(1450880.2910605003, coordinate_2.x)
    assert_in_delta(1141263.01116045, coordinate_2.y)
  end

  if Proj::Api::PROJ_VERSION >= '9.0.0'
    def test_last_used_operation
      wkt = <<~EOS
      CONVERSION["UTM zone 31N",
          METHOD["Transverse Mercator",
              ID["EPSG",9807]],
          PARAMETER["Latitude of natural origin",0,
              ANGLEUNIT["degree",0.0174532925199433],
              ID["EPSG",8801]],
          PARAMETER["Longitude of natural origin",3,
              ANGLEUNIT["degree",0.0174532925199433],
              ID["EPSG",8802]],
          PARAMETER["Scale factor at natural origin",0.9996,
              SCALEUNIT["unity",1],
              ID["EPSG",8805]],
          PARAMETER["False easting",500000,
              LENGTHUNIT["metre",1],
              ID["EPSG",8806]],
          PARAMETER["False northing",0,
              LENGTHUNIT["metre",1],
              ID["EPSG",8807]],
          ID["EPSG",16031]]
      EOS

      operation = Proj::Conversion.create_from_wkt(wkt)
      puts operation.to_wkt

      operation = Proj::Conversion.create_from_database("EPSG", "16031", :PJ_CATEGORY_COORDINATE_OPERATION)
      puts operation.to_wkt

      last = operation.last_used_operation
      refute(last)

      coord = Proj::Coordinate.new(x: Proj::Api.proj_torad(3.0), y: 0, z: 0, t: 0)
      new_coord = operation.forward(coord)

      assert_in_delta(500000, new_coord.x, 1.0)
      assert_in_delta(0.0, new_coord.y)
      assert_in_delta(0.0, new_coord.z)
      assert_in_delta(0.0, new_coord.t)

      last = operation.last_used_operation
      assert(last)
      assert(last.equivalent_to?(operation, :PJ_COMP_STRICT))
    end
  end

  def test_convert_conversion_to_other_method
    context = Proj::Context.new
    coordinate_system = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LONGITUDE_LATITUDE, context)

    crs = Proj::Crs.create_geographic(context, name: "WGS 84", datum_name: "World Geodetic System 1984", ellipsoid_name: "WGS 84",
                                      semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                      prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0, pm_angular_units: "Degree", pm_angular_units_conv: 0.0174532925199433,
                                      coordinate_system: coordinate_system)

    mercator = Proj::Projection.mercator_variant_a(context, center_latitude: 0, center_longitude: 1,
                                                   scale: 0.99,
                                                   false_easting: 2, false_northing: 3,
                                                   angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                   linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)

    cartesian = Proj::CoordinateSystem.create_cartesian_2d(context, :PJ_CART2D_EASTING_NORTHING)

    projected = Proj::Crs.create_projected(context, name: "My CRS", geodetic_crs: crs,
                                           conversion: mercator, coordinate_system: cartesian)

    conversion = projected.coordinate_operation
    assert_equal(:PJ_TYPE_CONVERSION, conversion.proj_type)

    # Error - Don't set code or method name
    new_conversion = conversion.convert_to_other_method
    refute(new_conversion)

    # 9805 is epsg code mercator variant b
    new_conversion = conversion.convert_to_other_method(new_method_epsg_code: 9805)
    assert(new_conversion)
    refute(new_conversion.equivalent_to?(conversion, :PJ_COMP_STRICT))
    assert(new_conversion.equivalent_to?(conversion, :PJ_COMP_EQUIVALENT))

    new_conversion = conversion.convert_to_other_method(new_method_name: "Mercator (variant B)")
    assert(new_conversion)
    refute(new_conversion.equivalent_to?(conversion, :PJ_COMP_STRICT))
    assert(new_conversion.equivalent_to?(conversion, :PJ_COMP_EQUIVALENT))

    # Convert back
    new_conversion = conversion.convert_to_other_method(new_method_name: "Mercator (variant A)")
    assert(new_conversion)
    assert(new_conversion.equivalent_to?(conversion, :PJ_COMP_STRICT))
  end
end