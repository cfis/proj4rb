# encoding: UTF-8

require_relative './abstract_test'

class ConversionTest < AbstractTest
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
    
    expected = <<~EOS
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

    assert_equal(expected.strip, proj_string)
  end

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

    assert_equal(0.05235987755982988, new_coord.x)
    assert_equal(0.0, new_coord.y)
    assert_equal(0.0, new_coord.z)
    assert_equal(0.0, new_coord.t)

    last = operation.last_used_operation
    assert(last)
    assert(last.equivalent_to?(operation, :PJ_COMP_STRICT))
  end

  def test_accuracy_coordinate_operation
    object = Proj::Conversion.create_from_database("EPSG", "1170", :PJ_CATEGORY_COORDINATE_OPERATION)
    assert_equal(16.0, object.accuracy)
  end

  def test_accuracy_projection
    object = Proj::Conversion.create("+proj=helmert")
    assert_equal(-1.0, object.accuracy)
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
end