# encoding: UTF-8

require_relative './abstract_test'

class DatumTest < AbstractTest
  def test_datum
    datum = Proj::PjObject.create_from_database("EPSG", "1061", :PJ_CATEGORY_DATUM)
    assert_equal(:PJ_TYPE_DYNAMIC_GEODETIC_REFERENCE_FRAME, datum.proj_type)
    assert_equal("International Terrestrial Reference Frame 2008", datum.name)
  end

  def test_frame_reference_epoch
    datum = Proj::PjObject.create_from_database("EPSG", "1061", :PJ_CATEGORY_DATUM)
    epoch = datum.frame_reference_epoch
    assert_equal(2005.0, epoch)
  end

  def test_ellipsoid
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
    ellipsoid = crs.ellipsoid
    assert_equal("WGS 84", ellipsoid.name)
    assert_equal(:PJ_TYPE_ELLIPSOID, ellipsoid.proj_type)

    ellipsoid_from_datum = crs.datum.ellipsoid
    assert_equal("WGS 84", ellipsoid_from_datum.name)
    assert_equal(:PJ_TYPE_ELLIPSOID, ellipsoid_from_datum.proj_type)

    assert(ellipsoid_from_datum.equivalent_to?(ellipsoid, :PJ_COMP_STRICT))
  end
end