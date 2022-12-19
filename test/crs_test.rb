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

  def test_create_from_proj4
    crs = Proj::Crs.new('+proj=longlat +datum=WGS84 +no_defs +type=crs')
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs.proj_type)
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
    500.times do
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
    crs = Proj::Crs.new('EPSG:4326')
    datum = crs.datum
    assert_equal(:PJ_TYPE_UNKNOWN, datum.proj_type)
  end

  def test_horizontal_datum
    crs = Proj::Crs.new('EPSG:4326')
    datum = crs.horizontal_datum
    assert_equal(:PJ_TYPE_DATUM_ENSEMBLE, datum.proj_type)
  end

  def test_coordinate_system
    crs = Proj::Crs.new('EPSG:4326')
    cs = crs.coordinate_system
    assert_equal(:PJ_TYPE_UNKNOWN, cs.proj_type)
  end

  def test_axis_count
    crs = Proj::Crs.new('EPSG:4326')
    count = crs.axis_count
    assert_equal(2, count)
  end

  def test_axis_info
    crs = Proj::Crs.new('EPSG:4326')
    info = crs.axis_info
    expected = [{:name=>"Geodetic latitude",
                 :abbreviation=>"Lat",
                 :direction=>"north",
                 :unit_conv_factor=>0.017453292519943295,
                 :unit_name=>"degree",
                 :unit_auth_name=>"EPSG",
                 :unit_code=>"9122"},
                {:name=>"Geodetic longitude",
                 :abbreviation=>"Lon",
                 :direction=>"east",
                 :unit_conv_factor=>0.017453292519943295,
                 :unit_name=>"degree",
                 :unit_auth_name=>"EPSG",
                 :unit_code=>"9122"}]

    assert_equal(expected, info)
  end

  def test_crs_type
    crs = Proj::Crs.new('EPSG:4326')
    crs_type = crs.crs_type
    assert_equal(:PJ_CS_TYPE_ELLIPSOIDAL, crs_type)
  end

  def test_ellipsoid
    crs = Proj::Crs.new('EPSG:4326')
    ellipsoid = crs.ellipsoid
    assert_equal(:PJ_TYPE_ELLIPSOID, ellipsoid.proj_type)
  end

  def test_prime_meridian
    crs = Proj::Crs.new('EPSG:4326')
    prime_meridian = crs.prime_meridian
    assert_equal('Greenwich', prime_meridian.name)
  end

  #def test_operation
  #  crs = Proj::Crs.new('EPSG:4326')
  #  operation = crs.operation
  #  assert_equal('Greenwich', operation.name)
  #end

  def test_area
    crs = Proj::Crs.new('EPSG:4326')
    assert_kind_of(Proj::Area, crs.area)
    assert_equal('World.', crs.area.name)
    assert_in_delta(-180.0, crs.area.west_lon_degree, 0.1)
    assert_in_delta(-90.0, crs.area.south_lat_degree, 0.1)
    assert_in_delta(180.0, crs.area.east_lon_degree, 0.1)
    assert_in_delta(90.0, crs.area.north_lat_degree, 0.1)
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
        "$schema": "https://proj.org/schemas/v0.5/projjson.schema.json",
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

  def test_inspect
    crs = Proj::Crs.new('EPSG:26915')

    expected = <<~EOS
      <Proj::Crs>: EPSG:26915
      NAD83 / UTM zone 15N
      Axis Info [PJ_CS_TYPE_CARTESIAN]:
      - E[east]: Easting (metre)
      - N[north]: Northing (metre)
      Area of Use:
      - name: North America - between 96°W and 90°W - onshore and offshore. Canada - Manitoba; Nunavut; Ontario. United States (USA) - Arkansas; Illinois; Iowa; Kansas; Louisiana; Michigan; Minnesota; Mississippi; Missouri; Nebraska; Oklahoma; Tennessee; Texas; Wisconsin.
      - bounds: (-96.0, 25.61, -90.0, 84.0)
      Coordinate operation:
      - name: ?
      - method: ?
      Datum: North American Datum 1983
      - Ellipsoid: GRS 1980
      - Prime Meridian: Greenwich
    EOS

    assert_equal(expected, crs.inspect)
  end
end