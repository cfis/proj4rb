# encoding: UTF-8

require_relative './abstract_test'

class EllipsoidTest < AbstractTest
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
    Proj::Crs.new(wkt)
  end

  def test_built_in
    ellipsoids = Proj::Ellipsoid.built_in.map {|ellipsoid| ellipsoid[:id] }
    assert(ellipsoids.include?('WGS84'))
    assert(ellipsoids.include?('bessel'))
    assert(ellipsoids.include?('lerch'))
  end

  def test_from_database
    ellipsoid = Proj::Ellipsoid.create_from_database("EPSG", "7030", :PJ_CATEGORY_ELLIPSOID)
    assert_instance_of(Proj::Ellipsoid, ellipsoid)
    assert_equal(:PJ_TYPE_ELLIPSOID, ellipsoid.proj_type)
    assert_equal("EPSG", ellipsoid.auth_name)
    assert_equal("WGS 84", ellipsoid.name)
    assert_equal("7030", ellipsoid.id_code)
  end

  def test_parameters
    ellipsoid = parameter_crs.ellipsoid
    params = ellipsoid.parameters

    expected = {semi_major_axis: 6378137.0,
                semi_minor_axis: 6356752.314245179,
                semi_minor_axis_computed: true,
                inverse_flattening: 298.257223563}
    assert_equal(expected, params)
  end

  def test_semi_major_axis
    meridian = parameter_crs.ellipsoid
    assert_equal(6378137.0, meridian.semi_major_axis)
  end

  def test_semi_minor_axis
    meridian = parameter_crs.ellipsoid
    assert_equal(6356752.314245179, meridian.semi_minor_axis)
  end

  def test_semi_minor_axis_computed
    meridian = parameter_crs.ellipsoid
    assert(meridian.semi_minor_axis_computed)
  end

  def test_inverse_flattening
    meridian = parameter_crs.ellipsoid
    assert_equal(298.257223563, meridian.inverse_flattening)
  end
end
