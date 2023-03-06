# encoding: UTF-8

require_relative './abstract_test'

class PrimeMeridianTest < AbstractTest
  def parameter_crs
    wkt = <<~EOS
    PROJCS["WGS 84 / UTM zone 31N",
           GEOGCS["WGS 84",
                  DATUM["WGS_1984",
                        SPHEROID["WGS 84",6378137,298.257223563,
                                 AUTHORITY["EPSG","7030"]],
                        AUTHORITY["EPSG","6326"]],
                  PRIMEM["Greenwich",0,
                         AUTHORITY["EPSG","8901"]],
                  UNIT["degree",0.0174532925199433,
                       AUTHORITY["EPSG","9122"]],
                  AUTHORITY["EPSG","4326"]],
           PROJECTION["Transverse_Mercator"],
           PARAMETER["latitude_of_origin",0],
           PARAMETER["central_meridian",3],
           PARAMETER["scale_factor",0.9996],
           PARAMETER["false_easting",500000],
           PARAMETER["false_northing",0],
           UNIT["metre",1,
                AUTHORITY["EPSG","9001"]],
           AXIS["Easting",EAST],
           AXIS["Northing",NORTH],
           AUTHORITY["EPSG","32631"]]
    EOS
    crs = Proj::Crs.new(wkt)
  end

  def test_built_in
    prime_meridians = Proj::PrimeMeridian.built_in.map {|prime_merdian| prime_merdian[:id] }
    assert(prime_meridians.include?('greenwich'))
    assert(prime_meridians.include?('athens'))
    assert(prime_meridians.include?('lisbon'))
    assert(prime_meridians.include?('rome'))
  end

  def test_from_database
    meridian = Proj::PrimeMeridian.create_from_database("EPSG", "8903", :PJ_CATEGORY_PRIME_MERIDIAN)
    assert_instance_of(Proj::PrimeMeridian, meridian)
    assert_equal(:PJ_TYPE_PRIME_MERIDIAN, meridian.proj_type)
    assert_equal("EPSG", meridian.auth_name)
    assert_equal("Paris", meridian.name)
    assert_equal("8903", meridian.id_code)
  end

  def test_parameters
    meridian = parameter_crs.prime_meridian
    params = meridian.parameters

    expected = {longitude: 0.0,
                unit_conv_factor: 0.017453292519943295,
                unit_name: "degree"}

    assert_equal(expected, params)
  end

  def test_longitude
    meridian = parameter_crs.prime_meridian
    assert_equal(0.0, meridian.longitude)
  end

  def test_unit_conv_factor
    meridian = parameter_crs.prime_meridian
    assert_equal(0.017453292519943295, meridian.unit_conv_factor)
  end

  def test_unit_name
    meridian = parameter_crs.prime_meridian
    assert_equal("degree", meridian.unit_name)
  end
end