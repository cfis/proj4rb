# encoding: UTF-8

require_relative './abstract_test'

class SessionTest < AbstractTest
  def teardown
    GC.start
  end

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

  def test_create_session
    session = Proj::Session.new
    assert(session)
  end

  def test_finalize
    50.times do
      crs = Proj::Session.new(Proj::Context.new)
      assert(crs.to_ptr)
      GC.start
    end
    assert(true)
  end

  def test_insert_statements
    crs = create_crs
    session = Proj::Session.new(crs.context)
    statements = session.get_insert_statements(crs, "HOBU", "XXXX")
    assert_equal(4, statements.count)

    expected = "INSERT INTO geodetic_datum VALUES('HOBU','GEODETIC_DATUM_XXXX','GDA2020','','EPSG','7019','EPSG','8901',NULL,NULL,NULL,NULL,0);"
    assert_equal(expected, statements[0])
  end

  def test_insert_statements_empty_authorities
    crs = create_crs

    session = Proj::Session.new(crs.context)
    statements = session.get_insert_statements(crs, "HOBU", "XXXX", false, [])
    assert_equal(6, statements.count)
  end

  def test_insert_statements_authorities_proj
    crs = create_crs

    session = Proj::Session.new(crs.context)
    statements = session.get_insert_statements(crs, "HOBU", "XXXX", false, ['EPSG'])
    assert_equal(4, statements.count)
  end

  def test_insert_twice
    crs = create_crs

    session = Proj::Session.new(crs.context)
    statements = session.get_insert_statements(crs, "HOBU", "XXXX")
    assert_equal(4, statements.count)

    statements = session.get_insert_statements(crs, "HOBU", "XXXX")
    assert_equal(0, statements.count)
  end
end