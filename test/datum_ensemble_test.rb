# encoding: UTF-8

require_relative './abstract_test'

class DatumEnsembleTest < AbstractTest
  def get_datum_ensemble
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
    crs.datum_ensemble
  end

  def test_count
    ensemble = get_datum_ensemble
    assert_equal(11, ensemble.count)
  end

  def test_member
    ensemble = get_datum_ensemble

    member = ensemble[0]
    assert_equal(:PJ_TYPE_GEODETIC_REFERENCE_FRAME, member.proj_type)
    assert_equal("European Terrestrial Reference Frame 1989", member.name)
  end

  def test_member_invalid
    ensemble = get_datum_ensemble
    member = ensemble[-1]
    refute(member)

    member = ensemble[100]
    refute(member)
  end

  def test_accuracy
    ensemble = get_datum_ensemble
    assert_equal(0.1, ensemble.accuracy)
  end
end