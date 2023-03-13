# encoding: UTF-8

require_relative './abstract_test'

class CrsTest < AbstractTest
  def test_create_from_epsg
    crs = Proj::Crs.new('EPSG:4326')
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs.proj_type)
    assert_equal('+proj=longlat +datum=WGS84 +no_defs +type=crs', crs.to_proj_string)

    assert_nil(crs.id)
    assert_equal('WGS 84', crs.description)
    assert_empty(crs.definition)
    refute(crs.has_inverse?)
    assert_equal(-1.0, crs.accuracy)
  end

  def test_create_from_urn
    crs = Proj::Crs.new('urn:ogc:def:crs:EPSG::4326')
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs.proj_type)
    assert_equal('+proj=longlat +datum=WGS84 +no_defs +type=crs', crs.to_proj_string)
  end

  def test_create_from_wkt
    crs = Proj::Crs.new(<<~EOS)
      GEOGCRS["WGS 84",
      DATUM["World Geodetic System 1984",
            ELLIPSOID["WGS 84",6378137,298.257223563,
                      LENGTHUNIT["metre",1]]],
      PRIMEM["Greenwich",0,
             ANGLEUNIT["degree",0.0174532925199433]],
      CS[ellipsoidal,2],
      AXIS["geodetic latitude (Lat)",north,
           ORDER[1],
           ANGLEUNIT["degree",0.0174532925199433]],
      AXIS["geodetic longitude (Lon)",east,
           ORDER[2],
           ANGLEUNIT["degree",0.0174532925199433]],
      USAGE[
          SCOPE["unknown"],
          AREA["World"],
          BBOX[-90,-180,90,180]],
      ID["EPSG",4326]]
    EOS

    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs.proj_type)
    assert_equal('+proj=longlat +datum=WGS84 +no_defs +type=crs', crs.to_proj_string)
  end

  def test_create_from_wkt_2
    wkt = <<~EOS
      GEOGCRS["WGS 84",
          DATUM["World Geodetic System 1984",
              ELLIPSOID["WGS 84",6378137,298.257223563,
                  LENGTHUNIT["metre",1]]],
          PRIMEM["Greenwich",0,
              ANGLEUNIT["degree",0.0174532925199433]],
          CS[ellipsoidal,2],
              AXIS["geodetic latitude (Lat)",north,
                  ORDER[1],
                  ANGLEUNIT["degree",0.0174532925199433]],
              AXIS["geodetic longitude (Lon)",east,
                  ORDER[2],
                  ANGLEUNIT["degree",0.0174532925199433]],
          USAGE[
              SCOPE["unknown"],
              AREA["World"],
              BBOX[-90,-180,90,180]],
          ID["EPSG",4326]]
    EOS

    crs = Proj::Crs.create_from_wkt(wkt)
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs.proj_type)
    assert_equal(wkt.strip, crs.to_wkt)
  end

  def test_create_from_wkt_warning
    wkt = <<~EOS
          PROJCS["test",
            GEOGCS["WGS 84",
              DATUM["WGS_1984",
                  SPHEROID["WGS 84",6378137,298.257223563]],
              PRIMEM["Greenwich",0],
              UNIT["degree",0.0174532925199433]],
            PROJECTION["Transverse_Mercator"],
            PARAMETER["latitude_of_origi",31],
            UNIT["metre",1]]"
          EOS
    wkt.strip!

    crs = nil
    _, err = capture_io do
      crs = Proj::Crs.create_from_wkt(wkt)
    end

    expected = "Cannot find expected parameter Latitude of natural origin. Cannot find expected parameter Longitude of natural origin. Cannot find expected parameter False easting. Cannot find expected parameter False northing. Parameter latitude_of_origi found but not expected for this method. The WKT string lacks a value for Scale factor at natural origin. Default it to 1."
    assert_equal(expected, err.strip)

    assert_equal(:PJ_TYPE_PROJECTED_CRS, crs.proj_type)
  end

  def test_create_from_wkt_error
    wkt = <<~EOS
      GEOGCS[test,
           DATUM[test,
              SPHEROID[test,0,298.257223563,unused]],
          PRIMEM[Greenwich,0],
          UNIT[degree,0.0174532925199433]]
    EOS
    wkt.strip!

    error = assert_raises(RuntimeError) do
      Proj::Crs.create_from_wkt(wkt)
    end

    expected = <<~EOS
                 Parsing error : syntax error, unexpected identifier, expecting string. Error occurred around:
                 GEOGCS[test,
                        ^
               EOS

    assert_equal(expected.strip, error.to_s)
  end

  def test_create_from_proj4
    crs = Proj::Crs.new('+proj=longlat +datum=WGS84 +no_defs +type=crs')
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs.proj_type)
    assert_equal('+proj=longlat +datum=WGS84 +no_defs +type=crs', crs.to_proj_string)
  end

  def test_create_from_database
    crs = Proj::Crs.create_from_database("EPSG", "4326", :PJ_CATEGORY_CRS)
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs.proj_type)
    assert_equal("4326", crs.id_code)
    assert_equal('+proj=longlat +datum=WGS84 +no_defs +type=crs', crs.to_proj_string)
  end

  def test_compound
    crs = Proj::Crs.new('EPSG:2393+5717')
    assert_equal(:PJ_TYPE_COMPOUND_CRS, crs.proj_type)
    assert_equal('+proj=tmerc +lat_0=0 +lon_0=27 +k=1 +x_0=3500000 +y_0=0 +ellps=intl +units=m +vunits=m +no_defs +type=crs', crs.to_proj_string)

    crs = Proj::Crs.new('urn:ogc:def:crs,crs:EPSG::2393,crs:EPSG::5717')
    assert_equal(:PJ_TYPE_COMPOUND_CRS, crs.proj_type)
    assert_equal('+proj=tmerc +lat_0=0 +lon_0=27 +k=1 +x_0=3500000 +y_0=0 +ellps=intl +units=m +vunits=m +no_defs +type=crs', crs.to_proj_string)
  end

  def test_not_crs
    error = assert_raises(Proj::Error) do
              Proj::Crs.new('+proj=utm +zone=32 +datum=WGS84')
            end
    assert_equal('Invalid crs definition. Proj created an instance of: PJ_TYPE_OTHER_COORDINATE_OPERATION.', error.message)
  end

  def test_finalize
    100.times do
      crs = Proj::Crs.new('EPSG:4326')
      assert(crs.to_ptr)
      GC.start
    end
    assert(true)
  end

  def test_geodetic_crs
    crs = Proj::Crs.new('EPSG:4326')
    geodetic = crs.geodetic_crs
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, geodetic.proj_type)
    assert_equal('+proj=longlat +datum=WGS84 +no_defs +type=crs', geodetic.to_proj_string)
  end

  def test_datum
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

    crs = Proj::Crs.create_from_wkt(wkt)
    datum = crs.datum
    assert_equal(:PJ_TYPE_GEODETIC_REFERENCE_FRAME, datum.proj_type)
  end

  def test_datum_forced
    wkt = <<~EOS
           GEOGCRS["ETRS89",
             ENSEMBLE["European Terrestrial Reference System 1989 ensemble",
                 MEMBER["European Terrestrial Reference Frame 1989"],
                 MEMBER["European Terrestrial Reference Frame 1990"],
                 MEMBER["European Terrestrial Reference Frame 1991"],
                 MEMBER["European Terrestrial Reference Frame 1992"],
                 MEMBER["European Terrestrial Reference Frame 1993"],
                 MEMBER["European Terrestrial Reference Frame 1994"],
                 MEMBER["European Terrestrial Reference Frame 1996"],
                 MEMBER["European Terrestrial Reference Frame 1997"],
                 MEMBER["European Terrestrial Reference Frame 2000"],
                 MEMBER["European Terrestrial Reference Frame 2005"],
                 MEMBER["European Terrestrial Reference Frame 2014"],
                 ELLIPSOID["GRS 1980",6378137,298.257222101,
                     LENGTHUNIT["metre",1]],
                 ENSEMBLEACCURACY[0.1]],  
             PRIMEM["Greenwich",0,
                 ANGLEUNIT["degree",0.0174532925199433]],
             CS[ellipsoidal,2],
                 AXIS["geodetic latitude (Lat)",north,
                     ORDER[1],
                     ANGLEUNIT["degree",0.0174532925199433]],
                 AXIS["geodetic longitude (Lon)",east,
                     ORDER[2],
                     ANGLEUNIT["degree",0.0174532925199433]]]
    EOS

    crs = Proj::Crs.create(wkt)
    datum = crs.datum_forced
    assert_equal("European Terrestrial Reference System 1989", datum.name)
  end

  def test_horizontal_datum
    crs = Proj::Crs.new('EPSG:4326')
    datum = crs.horizontal_datum
    assert_equal(:PJ_TYPE_DATUM_ENSEMBLE, datum.proj_type)
    assert_equal("World Geodetic System 1984 ensemble", datum.name)
  end

  def test_coordinate_system
    crs = Proj::Crs.new('EPSG:4326')
    assert(crs.coordinate_system)
  end

  def test_ellipsoid
    crs = Proj::Crs.new('EPSG:4326')
    ellipsoid = crs.ellipsoid
    assert_instance_of(Proj::Ellipsoid, ellipsoid)
    assert_equal(:PJ_TYPE_ELLIPSOID, ellipsoid.proj_type)
  end

  def test_prime_meridian
    crs = Proj::Crs.new('EPSG:4326')
    prime_meridian = crs.prime_meridian
    assert_instance_of(Proj::PrimeMeridian, prime_meridian)
    assert_equal('Greenwich', prime_meridian.name)
  end

  def test_coordinate_operation
    crs = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)

    conversion_1 = crs.coordinate_operation
    assert_equal("UTM zone 31N", conversion_1.name)
  end

  def test_area_of_use
    crs = Proj::Crs.new('EPSG:4326')
    assert_kind_of(Proj::Area, crs.area_of_use)
    assert_equal('World.', crs.area_of_use.name)
    assert_in_delta(-180.0, crs.area_of_use.west_lon_degree, 0.1)
    assert_in_delta(-90.0, crs.area_of_use.south_lat_degree, 0.1)
    assert_in_delta(180.0, crs.area_of_use.east_lon_degree, 0.1)
    assert_in_delta(90.0, crs.area_of_use.north_lat_degree, 0.1)
  end

  def test_derived
    crs = Proj::Crs.new('EPSG:4326')
    refute(crs.derived?)
  end

  def test_non_deprecated
    crs = Proj::Crs.new('EPSG:4226')
    objects = crs.non_deprecated
    assert_equal(2, objects.count)

    object = objects[0]
    assert_equal("#<Proj::Crs - Locodjo 1965, PJ_TYPE_GEOGRAPHIC_2D_CRS>", object.to_s)

    object = objects[1]
    assert_equal("#<Proj::Crs - Abidjan 1987, PJ_TYPE_GEOGRAPHIC_2D_CRS>", object.to_s)
  end

  def test_identify
    crs = Proj::Crs.new('OGC:CRS84')
    objects, confidences = crs.identify('OGC')

    assert_equal(1, objects.count)
    object = objects[0]
    assert_equal("#<Proj::Crs - WGS 84 (CRS84), PJ_TYPE_GEOGRAPHIC_2D_CRS>", object.to_s)

    assert_equal(1, confidences.count)
    confidence = confidences[0]
    assert_equal(100, confidence)
  end

  def test_lp_distance
    wkt = <<~EOS
      GEODCRS["WGS 84",
            DATUM["World Geodetic System 1984",
                  ELLIPSOID["WGS 84",6378137,298.257223563,
                            LENGTHUNIT["metre",1]]],
            PRIMEM["Greenwich",0,
                   ANGLEUNIT["degree",0.0174532925199433]],
            CS[ellipsoidal,2],
            AXIS["latitude",north,
                 ORDER[1],
                 ANGLEUNIT["degree",0.0174532925199433]],
            AXIS["longitude",east,
                 ORDER[2],
                 ANGLEUNIT["degree",0.0174532925199433]],
            ID["EPSG",4326]]
    EOS

    crs = Proj::Crs.new(wkt)
    coord1 = Proj::Coordinate.new(x: Proj.degrees_to_radians(2),
                                  y: Proj.degrees_to_radians(49),
                                  z: 0, t:0)
    coord2 = Proj::Coordinate.new(x: Proj.degrees_to_radians(2),
                                  y: Proj.degrees_to_radians(50),
                                  z: 0, t:0)

    distance = crs.lp_distance(coord1, coord2)
    assert_in_delta(111219.409, distance, 1e-3)
  end

  def test_geod_distance
    wkt = <<~EOS
      GEODCRS["WGS 84",
            DATUM["World Geodetic System 1984",
                  ELLIPSOID["WGS 84",6378137,298.257223563,
                            LENGTHUNIT["metre",1]]],
            PRIMEM["Greenwich",0,
                   ANGLEUNIT["degree",0.0174532925199433]],
            CS[ellipsoidal,2],
            AXIS["latitude",north,
                 ORDER[1],
                 ANGLEUNIT["degree",0.0174532925199433]],
            AXIS["longitude",east,
                 ORDER[2],
                 ANGLEUNIT["degree",0.0174532925199433]],
            ID["EPSG",4326]]
    EOS

    crs = Proj::Crs.new(wkt)
    coord1 = Proj::Coordinate.new(x: Proj.degrees_to_radians(2),
                                  y: Proj.degrees_to_radians(49),
                                  z: 0, t:0)
    coord2 = Proj::Coordinate.new(x: Proj.degrees_to_radians(2),
                                  y: Proj.degrees_to_radians(50),
                                  z: 0, t:0)

    coord3 = crs.geod_distance(coord1, coord2)
    assert_in_delta(111219.409, coord3.x, 1e-3)
  end

  def test_source_crs
    wkt = <<~EOS
            PROJCRS["WGS 84 / UTM zone 31N",
                BASEGEODCRS["WGS 84",
                    DATUM["World Geodetic System 1984",
                        ELLIPSOID["WGS 84",6378137,298.257223563,
                            LENGTHUNIT["metre",1]]],
                    PRIMEM["Greenwich",0,
                        ANGLEUNIT["degree",0.0174532925199433]]],
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
                        ID["EPSG",8807]]],
                CS[Cartesian,2],
                    AXIS["(E)",east,
                        ORDER[1],
                        LENGTHUNIT["metre",1]],
                    AXIS["(N)",north,
                        ORDER[2],
                        LENGTHUNIT["metre",1]],
                ID["EPSG",32631]]
    EOS

    crs = Proj::Crs.new(wkt)
    source_crs = crs.source_crs
    assert_equal("WGS 84", source_crs.name)
  end

  def test_target_crs
    wkt = <<~EOS
        BOUNDCRS[
          SOURCECRS[
            GEODCRS["NTF (Paris)",
                    DATUM["Nouvelle Triangulation Francaise (Paris)",
                          ELLIPSOID["Clarke 1880 (IGN)",6378249.2,293.466021293627,
                                    LENGTHUNIT["metre",1]]],
                    PRIMEM["Paris",2.5969213,
                           ANGLEUNIT["grad",0.015707963267949]],
                    CS[ellipsoidal,2],
                    AXIS["latitude",north,
                         ORDER[1],
                         ANGLEUNIT["grad",0.015707963267949]],
                    AXIS["longitude",east,
                         ORDER[2],
                         ANGLEUNIT["grad",0.015707963267949]],
                    ID["EPSG",4807]]],
          TARGETCRS[
            GEODCRS["WGS 84",
                    DATUM["World Geodetic System 1984",
                          ELLIPSOID["WGS 84",6378137,298.257223563,
                                    LENGTHUNIT["metre",1]]],
                    PRIMEM["Greenwich",0,
                           ANGLEUNIT["degree",0.0174532925199433]],
                    CS[ellipsoidal,2],
                    AXIS["latitude",north,
                         ORDER[1],
                         ANGLEUNIT["degree",0.0174532925199433]],
                    AXIS["longitude",east,
                         ORDER[2],
                         ANGLEUNIT["degree",0.0174532925199433]],
                    ID["EPSG",4326]]],
          ABRIDGEDTRANSFORMATION["",
                                 METHOD[""],
                                 PARAMETER["foo",1]]]
    EOS

    crs = Proj::Crs.new(wkt)
    target_crs = crs.target_crs
    assert_equal("WGS 84", target_crs.name)
  end

  def test_to_proj_string
    crs = Proj::Crs.new('EPSG:26915')
    assert_equal('+proj=utm +zone=15 +datum=NAD83 +units=m +no_defs +type=crs', crs.to_proj_string)
  end

  def test_to_wkt
    crs = Proj::Crs.new('EPSG:26915')

    expected = <<~EOS
      PROJCRS["NAD83 / UTM zone 15N",
          BASEGEOGCRS["NAD83",
              DATUM["North American Datum 1983",
                  ELLIPSOID["GRS 1980",6378137,298.257222101,
                      LENGTHUNIT["metre",1]]],
              PRIMEM["Greenwich",0,
                  ANGLEUNIT["degree",0.0174532925199433]],
              ID["EPSG",4269]],
          CONVERSION["UTM zone 15N",
              METHOD["Transverse Mercator",
                  ID["EPSG",9807]],
              PARAMETER["Latitude of natural origin",0,
                  ANGLEUNIT["degree",0.0174532925199433],
                  ID["EPSG",8801]],
              PARAMETER["Longitude of natural origin",-93,
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
                  ID["EPSG",8807]]],
          CS[Cartesian,2],
              AXIS["(E)",east,
                  ORDER[1],
                  LENGTHUNIT["metre",1]],
              AXIS["(N)",north,
                  ORDER[2],
                  LENGTHUNIT["metre",1]],
          USAGE[
              SCOPE["Engineering survey, topographic mapping."],
              AREA["North America - between 96\xC2\xB0W and 90\xC2\xB0W - onshore and offshore. Canada - Manitoba; Nunavut; Ontario. United States (USA) - Arkansas; Illinois; Iowa; Kansas; Louisiana; Michigan; Minnesota; Mississippi; Missouri; Nebraska; Oklahoma; Tennessee; Texas; Wisconsin."],
              BBOX[25.61,-96,84,-90]],
          ID["EPSG",26915]]
      EOS

    assert_equal(expected.strip, crs.to_wkt)
  end

  def test_to_json
    crs = Proj::Crs.new('EPSG:26915')
    expected = <<~EOS
      {
        "$schema": "https://proj.org/schemas/#{proj9? ? 'v0.5' : 'v0.4'}/projjson.schema.json",
        "type": "ProjectedCRS",
        "name": "NAD83 / UTM zone 15N",
        "base_crs": {
          "name": "NAD83",
          "datum": {
            "type": "GeodeticReferenceFrame",
            "name": "North American Datum 1983",
            "ellipsoid": {
              "name": "GRS 1980",
              "semi_major_axis": 6378137,
              "inverse_flattening": 298.257222101
            }
          },
          "coordinate_system": {
            "subtype": "ellipsoidal",
            "axis": [
              {
                "name": "Geodetic latitude",
                "abbreviation": "Lat",
                "direction": "north",
                "unit": "degree"
              },
              {
                "name": "Geodetic longitude",
                "abbreviation": "Lon",
                "direction": "east",
                "unit": "degree"
              }
            ]
          },
          "id": {
            "authority": "EPSG",
            "code": 4269
          }
        },
        "conversion": {
          "name": "UTM zone 15N",
          "method": {
            "name": "Transverse Mercator",
            "id": {
              "authority": "EPSG",
              "code": 9807
            }
          },
          "parameters": [
            {
              "name": "Latitude of natural origin",
              "value": 0,
              "unit": "degree",
              "id": {
                "authority": "EPSG",
                "code": 8801
              }
            },
            {
              "name": "Longitude of natural origin",
              "value": -93,
              "unit": "degree",
              "id": {
                "authority": "EPSG",
                "code": 8802
              }
            },
            {
              "name": "Scale factor at natural origin",
              "value": 0.9996,
              "unit": "unity",
              "id": {
                "authority": "EPSG",
                "code": 8805
              }
            },
            {
              "name": "False easting",
              "value": 500000,
              "unit": "metre",
              "id": {
                "authority": "EPSG",
                "code": 8806
              }
            },
            {
              "name": "False northing",
              "value": 0,
              "unit": "metre",
              "id": {
                "authority": "EPSG",
                "code": 8807
              }
            }
          ]
        },
        "coordinate_system": {
          "subtype": "Cartesian",
          "axis": [
            {
              "name": "Easting",
              "abbreviation": "E",
              "direction": "east",
              "unit": "metre"
            },
            {
              "name": "Northing",
              "abbreviation": "N",
              "direction": "north",
              "unit": "metre"
            }
          ]
        },
        "scope": "Engineering survey, topographic mapping.",
        "area": "North America - between 96\xC2\xB0W and 90\xC2\xB0W - onshore and offshore. Canada - Manitoba; Nunavut; Ontario. United States (USA) - Arkansas; Illinois; Iowa; Kansas; Louisiana; Michigan; Minnesota; Mississippi; Missouri; Nebraska; Oklahoma; Tennessee; Texas; Wisconsin.",
        "bbox": {
          "south_latitude": 25.61,
          "west_longitude": -96,
          "north_latitude": 84,
          "east_longitude": -90
        },
        "id": {
          "authority": "EPSG",
          "code": 26915
        }
      }
    EOS

    assert_equal(expected.strip, crs.to_json)
  end

  def test_to_wgs84
    wkt = <<~EOS
      BOUNDCRS[
          SOURCECRS[
              GEOGCRS["NTF (Paris)",
                  DATUM["Nouvelle Triangulation Francaise (Paris)",
                      ELLIPSOID["Clarke 1880 (IGN)",6378249.2,293.466021293627,
                          LENGTHUNIT["metre",1]]],
                  PRIMEM["Paris",2.5969213,
                      ANGLEUNIT["grad",0.0157079632679489]],
                  CS[ellipsoidal,2],
                      AXIS["geodetic latitude (Lat)",north,
                          ORDER[1],
                          ANGLEUNIT["grad",0.0157079632679489]],
                      AXIS["geodetic longitude (Lon)",east,
                          ORDER[2],
                          ANGLEUNIT["grad",0.0157079632679489]],
                  USAGE[
                      SCOPE["Geodesy."],
                      AREA["France - onshore - mainland and Corsica."],
                      BBOX[41.31,-4.87,51.14,9.63]],
                  ID["EPSG",4807]]],
          TARGETCRS[
              GEOGCRS["WGS 84",
                  DATUM["World Geodetic System 1984",
                      ELLIPSOID["WGS 84",6378137,298.257223563,
                          LENGTHUNIT["metre",1]]],
                  PRIMEM["Greenwich",0,
                      ANGLEUNIT["degree",0.0174532925199433]],
                  CS[ellipsoidal,2],
                      AXIS["latitude",north,
                          ORDER[1],
                          ANGLEUNIT["degree",0.0174532925199433]],
                      AXIS["longitude",east,
                          ORDER[2],
                          ANGLEUNIT["degree",0.0174532925199433]],
                  ID["EPSG",4326]]],
          ABRIDGEDTRANSFORMATION["NTF to WGS 84 (1)",
              VERSION["IGN-Fra"],
              METHOD["Geocentric translations (geog2D domain)",
                  ID["EPSG",9603]],
              PARAMETER["X-axis translation",-168,
                  ID["EPSG",8605]],
              PARAMETER["Y-axis translation",-60,
                  ID["EPSG",8606]],
              PARAMETER["Z-axis translation",320,
                  ID["EPSG",8607]],
              USAGE[
                  SCOPE["(null/copy) Approximation for medium and low accuracy applications assuming equality between plate-fixed static and earth-fixed dynamic CRSs, ignoring static/dynamic CRS differences."],
                  AREA["France - onshore - mainland and Corsica."],
                  BBOX[41.31,-4.87,51.14,9.63]],
              ID["EPSG",1193],
              REMARK["These same parameter values are used to transform to ETRS89. See NTF to ETRS89 (1) (code 1651)."]]]
    EOS

    crs = Proj::Crs.new(wkt)
    operation = crs.coordinate_operation
    values = operation.to_wgs84

    expected = [-168.0, -60.0, 320.0, 0.0, 0.0, 0.0, 0.0]
    assert_equal(expected, values)
  end

  def test_geographic
    context = Proj::Context.new
    coordinate_system = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LATITUDE_LONGITUDE, context)

    crs = Proj::Crs.create_geographic(context, name: "WGS 84", datum_name: "World Geodetic System 1984", ellps_name: "WGS 84",
                                      semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                      prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0, pm_angular_units: "Degree", pm_units_conv: 0.0174532925199433,
                                      coordinate_system: coordinate_system)

    crs_2 = Proj::Crs.create_from_database("EPSG", "4326", :PJ_CATEGORY_CRS)
    assert(crs.equivalent_to?(crs_2, :PJ_COMP_EQUIVALENT))
  end

  def test_geographic_datum
    context = Proj::Context.new
    coordinate_system = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LONGITUDE_LATITUDE, context)
    datum = Proj::PjObject.create_from_database("EPSG", "1061", :PJ_CATEGORY_DATUM)
    crs = Proj::Crs.create_geographic_from_datum(context, name: "WGS 84", datum: datum, coordinate_system: coordinate_system)
  end

  def test_geocentric
    context = Proj::Context.new
    crs = Proj::Crs.create_geocentric(context, name: "WGS 84", datum_name: "World Geodetic System 1984", ellps_name: "WGS 84",
                                      semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                      prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0,
                                      angular_units: "Degree", angular_units_conv: 0.0174532925199433,
                                      linear_units: "Metre", linear_units_conv: 1.0)

    crs_2 = Proj::Crs.create_from_database("EPSG", "4978", :PJ_CATEGORY_CRS)
    assert(crs.equivalent_to?(crs_2, :PJ_COMP_EQUIVALENT))
  end

  def test_geocentric_datum
    context = Proj::Context.new
    crs = Proj::Crs.create_geocentric(context, name: "WGS 84", datum_name: "World Geodetic System 1984", ellps_name: "WGS 84",
                                      semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                      prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0,
                                      angular_units: "Degree", angular_units_conv: 0.0174532925199433,
                                      linear_units: "Metre", linear_units_conv: 1.0)
    datum = crs.datum

    geocentric_crs = Proj::Crs.create_geocentric_from_datum(context, name: "WGS 84", datum: datum,
                                                            linear_units: "Metre", linear_units_conv: 1.0)

    assert(crs.equivalent_to?(geocentric_crs, :PJ_COMP_STRICT))
  end

  def test_vertical_crs_ex
    context = Proj::Context.new

    vertical_crs = Proj::Crs.create_vertical_ex(context, name: "myVertCRS (ftUS)",
                                                datum_name: "myVertDatum",
                                                linear_units: "US survey foot", linear_units_conv: 0.304800609601219,
                                                geoid_model_name: "PROJ @foo.gtx",
                                                accuracy: 123)
    assert(vertical_crs)
    assert_equal(:PJ_TYPE_VERTICAL_CRS, vertical_crs.proj_type)
  end

  def test_vertical_crs_ex_with_geog_crs
    context = Proj::Context.new
    # NAD83(2011) / UTM zone 11N
    horizontal_crs = Proj::Crs.create_from_database("EPSG", "6340", :PJ_CATEGORY_CRS)

    # WGS84
    wgs84 = Proj::Crs.new("EPSG:4979", context)

    vertical_crs = Proj::Crs.create_vertical_ex(context, name: "myVertCRS",
                                                datum_name: "myVertDatum",
                                                linear_units: "US survey foot", linear_units_conv: 0.304800609601219,
                                                geoid_model_name: "PROJ @foo.gtx",
                                                geoid_geog_crs: wgs84)
    assert(vertical_crs)
    assert_equal(:PJ_TYPE_VERTICAL_CRS, vertical_crs.proj_type)
  end

  def test_bound_vertical
    context = Proj::Context.new
    vertical_crs = Proj::Crs.create_vertical_ex(context, name: "myVertCRS",
                                                datum_name: "myVertDatum")

    crs_4979 = Proj::Crs.create_from_database("EPSG", "4979", :PJ_CATEGORY_CRS)
    bound = Proj::Crs.create_bound_vertical(context, vertical_crs: vertical_crs,
                                            hub_crs: crs_4979, grid_name: "foo.gtx")

    assert_equal(:PJ_TYPE_BOUND_CRS, bound.proj_type)
    assert_equal("myVertCRS", bound.name)
  end

  def test_compound
    context = Proj::Context.new
    coordinate_system = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LONGITUDE_LATITUDE, context)

    horizontal_crs = Proj::Crs.create_geographic(context, name: "WGS 84", datum_name: "World Geodetic System 1984", ellps_name: "WGS 84",
                                                 semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                                 prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0, pm_angular_units: "Degree", pm_units_conv: 0.0174532925199433,
                                                 coordinate_system: coordinate_system)

    vertical_crs = Proj::Crs.create_vertical(context, name: "myVertCRS",
                                             datum_name: "myVertDatum",
                                             linear_units: "US survey foot", linear_units_conv: 0.304800609601219)

    assert(vertical_crs)
    assert_equal(:PJ_TYPE_VERTICAL_CRS, vertical_crs.proj_type)
    assert_equal("myVertCRS", vertical_crs.name)

    compound_crs = Proj::Crs.create_compound(context, name: "myCompoundCRS",
                                             horizontal_crs: horizontal_crs, vertical_crs: vertical_crs);
    assert(compound_crs)
    assert_equal(:PJ_TYPE_COMPOUND_CRS, compound_crs.proj_type)
    assert_equal("myCompoundCRS", compound_crs.name)

    crs = compound_crs.sub_crs(0)
    assert(crs.equivalent_to?(horizontal_crs, :PJ_COMP_STRICT))

    crs = compound_crs.sub_crs(1)
    assert(crs.equivalent_to?(vertical_crs, :PJ_COMP_STRICT))
  end

  def test_derived_geographic
    context = Proj::Context.new
    crs = Proj::Crs.create("EPSG:4326", context)

    conversion = Proj::Conversion.pole_rotation_grib_convention(context, south_pole_lat_in_unrotated_crs: 2, south_pole_long_in_unrotated_crs: 3,
                                                                axis_rotation: 4, ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433)

    coordinate_system = crs.coordinate_system

    # Wrong type of base_geographic_crs
    derived_crs = Proj::Crs.create_derived_geographic(context, name: "my rotated CRS",
                                                      base_geographic_crs: conversion, conversion: conversion,
                                                      coordinate_system: coordinate_system)
    refute(derived_crs)

    # Wrong type of conversion
    derived_crs = Proj::Crs.create_derived_geographic(context, name: "my rotated CRS",
                                                      base_geographic_crs: crs, conversion: crs,
                                                      coordinate_system: coordinate_system)
    refute(derived_crs)

    derived_crs = Proj::Crs.create_derived_geographic(context, name: "my rotated CRS",
                                                      base_geographic_crs: crs, conversion: conversion,
                                                      coordinate_system: coordinate_system)
    refute(crs.derived?)
    assert(derived_crs.derived?)

    expected = "+proj=ob_tran +o_proj=longlat +o_lon_p=-4 +o_lat_p=-2 +lon_0=3 +datum=WGS84 +no_defs +type=crs"
    assert_equal(expected, derived_crs.to_proj_string)
  end

  def test_projected
    context = Proj::Context.new
    param = Proj::Parameter.new(name: "param name", value: 0.99,
                                unit_conv_factor: 1.0, unit_type: :PJ_UT_SCALE)

    conversion = Proj::Conversion.create_conversion(context, name: "conv",
                                                    auth_name: "conv auth", code: "conv code",
                                                    method_name: "method", method_auth_name: "method auth", method_code: "method code",
                                                    params: [param])

    coordinate_system = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LONGITUDE_LATITUDE, context)
    crs = Proj::Crs.create_geographic(context, name: "WGS 84", datum_name: "World Geodetic System 1984",
                                      ellps_name: "WGS 84", semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                      prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0,
                                      pm_angular_units: "Degree", pm_units_conv: 0.0174532925199433,
                                      coordinate_system: coordinate_system)

    cartesian = Proj::CoordinateSystem.create_cartesian_2d(context, :PJ_CART2D_EASTING_NORTHING)

    projected = Proj::Crs.create_projected(context, name: "My Projected CRS", geodetic_crs: crs,
                                           conversion: conversion, coordinate_system: cartesian)
    assert_equal(:PJ_TYPE_PROJECTED_CRS, projected.proj_type)
    assert_equal("My Projected CRS", projected.name)
  end

  def test_create_bound_crs_to_wgs84
    context = Proj::Context.new
    crs = Proj::Crs.create_from_database("EPSG", "4807", :PJ_CATEGORY_CRS)

    bounded = Proj::Crs.create_bound_to_wgs84(context, crs: crs)
    expected = "+proj=longlat +ellps=clrk80ign +pm=paris +towgs84=-168,-60,320,0,0,0,0 +no_defs +type=crs"
    assert_equal(expected, bounded.to_proj_string)

    base_crs = bounded.source_crs
    assert(base_crs.equivalent_to?(crs, :PJ_COMP_EQUIVALENT))

    hub_crs = bounded.target_crs
    wgs84_crs = Proj::Crs.create_from_database("EPSG", "4326", :PJ_CATEGORY_CRS)
    assert(hub_crs.equivalent_to?(wgs84_crs, :PJ_COMP_EQUIVALENT))

    transform = bounded.coordinate_operation
    values = transform.to_wgs84(true)
    expected = [-168, -60, 320, 0, 0, 0, 0]
    assert_equal(expected, values)

    bounded_2 = Proj::Crs.create_bound(context, base_crs: base_crs, hub_crs: hub_crs, transformation: transform)
    assert_equal(:PJ_TYPE_BOUND_CRS, bounded_2.proj_type)
    expected = "+proj=longlat +ellps=clrk80ign +pm=paris +towgs84=-168,-60,320,0,0,0,0 +no_defs +type=crs"
    assert_equal(expected, bounded_2.to_proj_string)
  end

  def test_create_engineering
    context = Proj::Context.new
    crs = Proj::Crs.create_engineering("EPSG", name: "4807")
    assert_equal("4807", crs.name)
    assert_equal(:PJ_TYPE_ENGINEERING_CRS, crs.proj_type)

    expected = <<~EOS
        LOCAL_CS["name",
            UNIT["metre",1,
                AUTHORITY["EPSG","9001"]],
            AXIS["Easting",EAST],
            AXIS["Northing",NORTH]]
    EOS

    # This crashes proj
    #assert_equal(expected, crs.to_wkt(:PJ_WKT1_GDAL))
  end

  def test_query_geodetic_from_datum
    context = Proj::Context.new
    crses = Proj::Crs.query_geodetic_from_datum(context, datum_auth_name: "EPSG", datum_code: "6326")
    assert_equal(12, crses.size)

    crses = Proj::Crs.query_geodetic_from_datum(context, auth_name: "EPSG",
                                                datum_auth_name: "EPSG", datum_code: "6326",
                                                crs_type: "geographic 2D")
    assert_equal(1, crses.size)
  end

  def test_alter_name
    context = Proj::Context.new
    coordinate_system = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LATITUDE_LONGITUDE, context)

    crs = Proj::Crs.create_geographic(context, name: "WGS 84", datum_name: "World Geodetic System 1984", ellps_name: "WGS 84",
                                      semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                      prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0, pm_angular_units: "Degree", pm_units_conv: 0.0174532925199433,
                                      coordinate_system: coordinate_system)
    assert_equal("WGS 84", crs.name)

    altered = crs.alter_name("new name")
    assert_equal("WGS 84", crs.name)
    assert_equal("new name", altered.name)
  end

  def test_alter_id
    context = Proj::Context.new
    coordinate_system = Proj::CoordinateSystem.create_ellipsoidal_2d(:PJ_ELLPS2D_LATITUDE_LONGITUDE, context)

    crs = Proj::Crs.create_geographic(context, name: "WGS 84", datum_name: "World Geodetic System 1984", ellps_name: "WGS 84",
                                      semi_major_meter: 6378137, inv_flattening: 298.257223563,
                                      prime_meridian_name: "Greenwich", prime_meridian_offset: 0.0, pm_angular_units: "Degree", pm_units_conv: 0.0174532925199433,
                                      coordinate_system: coordinate_system)
    refute(crs.auth)

    altered = crs.alter_id("auth", "code")
    refute(crs.auth)
    assert_equal("auth:code", altered.auth)
  end

  def test_alter_geodetic_crs
    context = Proj::Context.new
    projected = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    geod_crs = projected.geodetic_crs
    new_geod_crs = Proj::Crs.new("+proj=longlat +type=crs", context)

    altered = geod_crs.alter_geodetic_crs(new_geod_crs)
    assert(altered.equivalent_to?(new_geod_crs, :PJ_COMP_STRICT))

    altered = projected.alter_geodetic_crs(new_geod_crs)
    assert_equal(:PJ_TYPE_PROJECTED_CRS, altered.proj_type)
    assert(altered.geodetic_crs.equivalent_to?(new_geod_crs, :PJ_COMP_STRICT))
  end

  def test_alter_cs_angular_unit
    context = Proj::Context.new
    crs = Proj::Crs.new('EPSG:4326')
    altered = crs.alter_cs_angular_unit(angular_units: "my unit", angular_units_conv: 2,
                                        unit_auth_name: "my auth", unit_code: "my code")

    cs = altered.coordinate_system
    assert_equal(2, cs.axis_count)

    axis = cs.axis_info(0)
    assert_equal("my unit", axis.unit_name)
    assert_equal(2, axis.unit_conv_factor)
    assert_equal("my auth", axis.unit_auth_name)
    assert_equal("my code", axis.unit_code)
  end

  def test_alter_alter_cs_linear_unit
    context = Proj::Context.new
    projected = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    altered = projected.alter_cs_linear_unit(linear_units: "my unit", linear_units_conv: 2,
                                             unit_auth_name: "my auth", unit_code: "my code")

    cs = altered.coordinate_system
    assert_equal(2, cs.axis_count)

    axis = cs.axis_info(0)
    assert_equal("my unit", axis.unit_name)
    assert_equal(2, axis.unit_conv_factor)
    assert_equal("my auth", axis.unit_auth_name)
    assert_equal("my code", axis.unit_code)
  end

  def test_alter_parameters_linear_unit
    context = Proj::Context.new
    projected = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    altered = projected.alter_parameters_linear_unit(linear_units: "my unit", linear_units_conv: 2,
                                                     convert_to_new_unit: false)

    wkt = altered.to_wkt
    assert_match(/500000/, wkt)
    assert_match(/"my unit",2/, wkt)
  end

  def test_promote_to_3d
    context = Proj::Context.new
    crs = Proj::Crs.new('EPSG:4326')

    crs_3d = crs.promote_to_3d
    assert_equal("4979", crs_3d.id_code)

    cs = crs_3d.coordinate_system
    assert_equal(3, cs.axis_count)
  end

  def test_demote_to_3d
    context = Proj::Context.new
    crs = Proj::Crs.new('EPSG:4979')

    crs_2d = crs.demote_to_2d
    assert_equal("4326", crs_2d.id_code)

    cs = crs_2d.coordinate_system
    assert_equal(2, cs.axis_count)
  end

  def test_projected_3d_with_base
    context = Proj::Context.new
    projected = Proj::Crs.new('EPSG:32631')
    base_crs_3d = Proj::Crs.create_from_database("EPSG", "4979", :PJ_CATEGORY_CRS)

    crs_3d = projected.projected_3d(geog_3d_crs: base_crs_3d)
    assert_equal(:PJ_TYPE_PROJECTED_CRS, crs_3d.proj_type)
    assert_equal(crs_3d.name, projected.name)

    cs = crs_3d.coordinate_system
    assert_equal(3, cs.axis_count)
  end

  def test_projected_3d_without_base
    context = Proj::Context.new
    projected = Proj::Crs.new('EPSG:32631')

    crs_3d = projected.projected_3d
    assert_equal(:PJ_TYPE_PROJECTED_CRS, crs_3d.proj_type)
    assert_equal(crs_3d.name, projected.name)

    cs = crs_3d.coordinate_system
    assert_equal(3, cs.axis_count)
  end
end