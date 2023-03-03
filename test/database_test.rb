# encoding: UTF-8

require_relative './abstract_test'

class DatabaseTest < AbstractTest
  def create_crs
    Proj::Crs.new(<<~EOS)
      GEOGCRS["myGDA2020",
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
                ANGLEUNIT["degree",0.0174532925199433]]]
    EOS
  end

  def test_path
    database = Proj::Database.new(Proj::Context.current)
    assert_equal("proj.db", File.basename(database.path))
  end

  def test_set_path_error
    database = Proj::Database.new(Proj::Context.current)

    error = assert_raises(Proj::Error) do
      database.path = "test.db"
    end
    assert_equal("Unknown error (code 4096)", error.to_s)
  end

  def test_structure
    database = Proj::Database.new(Proj::Context.current)
    structure = database.structure
    assert(structure.length > 70)
  end

  def test_metadata
    database = Proj::Database.new(Proj::Context.current)
    metadata = database.metadata('IGNF.VERSION')
    assert_equal('3.1.0', metadata)
  end

  def test_codes
    types_with_no_codes = [:PJ_TYPE_TEMPORAL_CRS, :PJ_TYPE_BOUND_CRS, :PJ_TYPE_UNKNOWN, :PJ_TYPE_ENGINEERING_CRS,
                           :PJ_TYPE_TEMPORAL_DATUM, :PJ_TYPE_ENGINEERING_DATUM, :PJ_TYPE_PARAMETRIC_DATUM,
                           :PJ_TYPE_OTHER_COORDINATE_OPERATION]

    database = Proj::Database.new(Proj::Context.current)

    Proj::Api::PJ_TYPE.symbols.each do |type|
      codes = database.codes('EPSG', type)
      if types_with_no_codes.include?(type)
        assert(codes.empty?)
      else
        refute(codes.empty?)
      end
    end
  end

  def test_authorities
    database = Proj::Database.new(Proj::Context.current)
    authorities = database.authorities
    assert_equal(7, authorities.count)

    authority = authorities[0]
    assert_equal('EPSG', authority)

    authority = authorities[1]
    assert_equal('ESRI', authority)

    authority = authorities[2]
    assert_equal('IAU_2015', authority)

    authority = authorities[3]
    assert_equal('IGNF', authority)

    authority = authorities[4]
    assert_equal('NKG', authority)

    authority = authorities[5]
    assert_equal('OGC', authority)

    authority = authorities[6]
    assert_equal('PROJ', authority)
  end

  def test_crs_info
    database = Proj::Database.new(Proj::Context.current)
    crs_infos = database.crs_info

    expected = case
               when proj8?
                 13107
               else
                 12609
               end
    assert_equal(expected, crs_infos.count)

    crs_info = crs_infos.first
    assert_equal("EPSG", crs_info.auth_name)
    assert_equal("2000", crs_info.code)
    assert_equal("Anguilla 1957 / British West Indies Grid", crs_info.name)
    assert_equal(:PJ_TYPE_PROJECTED_CRS, crs_info.type)
    refute(crs_info.deprecated)
    assert(crs_info.bbox_valid)
    assert_equal(-63.22, crs_info.west_lon_degree)
    assert_equal(18.11, crs_info.south_lat_degree)
    assert_equal(-62.92, crs_info.east_lon_degree)
    assert_equal(18.33, crs_info.north_lat_degree)
    assert_equal("Anguilla - onshore.", crs_info.area_name)
    assert_equal("Transverse Mercator", crs_info.projection_method_name)
    assert_equal("Earth", crs_info.celestial_body_name)
  end

  def test_crs_info_epsg
    database = Proj::Database.new(Proj::Context.current)
    crs_infos = database.crs_info("EPSG")

    expected = case
               when proj8?
                 7251
               else
                 7056
               end
    assert_equal(expected, crs_infos.count)
  end

  def test_crs_info_geodetic
    database = Proj::Database.new(Proj::Context.current)
    params = Proj::Parameters.new
    params.types = [:PJ_TYPE_GEODETIC_CRS]
    crs_infos = database.crs_info("EPSG", params)

    expected = case
               when proj8?
                 943
               else
                 930
               end

    assert_equal(expected, crs_infos.count)
  end

  def test_crs_info_geographic
    database = Proj::Database.new(Proj::Context.current)
    params = Proj::Parameters.new
    params.types = [:PJ_TYPE_GEOGRAPHIC_2D_CRS, :PJ_TYPE_PROJECTED_CRS]
    crs_infos = database.crs_info("EPSG", params)

    expected = case
               when proj8?
                 5689
               else
                 5534
               end

    assert_equal(expected, crs_infos.count)
  end

  def test_geoid_models
    database = Proj::Database.new(Proj::Context.current)
    models = database.geoid_models("EPSG", "5703")

    assert_equal(8, models.size)

    expected = %w[GEOID03 GEOID06 GEOID09 GEOID12A GEOID12B GEOID18 GEOID99 GGM10]
    assert_equal(expected, models.strings)
  end

  def test_celestial_bodies
    database = Proj::Database.new(Proj::Context.current)
    bodies = database.celestial_bodies

    expected = case
               when proj8?
                 176
               else
                 170
               end

    assert_equal(expected, bodies.size)

    celestial_body = bodies[0]
    assert_equal('ESRI', celestial_body.auth_name)
    assert_equal('1_Ceres', celestial_body.name)
  end

  def test_celestial_bodies_authority
    database = Proj::Database.new(Proj::Context.current)
    bodies = database.celestial_bodies('ESRI')

    expected = case
               when proj8?
                 78
               else
                 72
               end

    assert_equal(expected, bodies.size)

    celestial_body = bodies[0]
    assert_equal('ESRI', celestial_body.auth_name)
    assert_equal('1_Ceres', celestial_body.name)
  end

  def test_suggest_code_for
    crs = create_crs
    database = Proj::Database.new(crs.context)

    code = database.suggest_code_for(crs, "HOBU", false)
    assert_equal("MYGDA2020", code)

    code = database.suggest_code_for(crs, "HOBU", true)
    assert_equal("1", code)
  end

  def test_celestial_body_name_geographic_crs
    crs = Proj::Crs.create_from_database("EPSG", "4326", :PJ_CATEGORY_CRS)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_geographic_projected_crs
    crs = Proj::Crs.create_from_database("EPSG", "32631", :PJ_CATEGORY_CRS)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_vertical_crs
    crs = Proj::Crs.create_from_database("EPSG", "3855", :PJ_CATEGORY_CRS)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_compound_crs
    crs = Proj::Crs.create_from_database("EPSG", "9518", :PJ_CATEGORY_CRS)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_geodetic_datum
    crs = Proj::Crs.create_from_database("EPSG", "6267", :PJ_CATEGORY_DATUM)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_datum_ensemble
    crs = Proj::Crs.create_from_database("EPSG", "6326", :PJ_CATEGORY_DATUM_ENSEMBLE)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_vertical_datum
    crs = Proj::Crs.create_from_database("EPSG", "1027", :PJ_CATEGORY_DATUM)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_ellipsoid
    crs = Proj::Crs.create_from_database("EPSG", "7030", :PJ_CATEGORY_ELLIPSOID)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Earth", name)
  end

  def test_celestial_body_name_ellipsoid_not_earth
    crs = Proj::Crs.create_from_database("ESRI", "107903", :PJ_CATEGORY_ELLIPSOID)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    assert_equal("Moon", name)
  end

  def test_celestial_body_name_error
    crs = Proj::Crs.create_from_database("EPSG", "1591", :PJ_CATEGORY_COORDINATE_OPERATION)
    database = Proj::Database.new(crs.context)
    name = database.celestial_body_name(crs)
    refute(name)
  end

  if proj7?
    # This test causes a segmentation fault on proj6
    def test_metadata_invalid
      database = Proj::Database.new(Proj::Context.current)
      metadata = database.metadata('foo')
      refute(metadata)
    end
  end
end