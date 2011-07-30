# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class CreateProjectionTest < Test::Unit::TestCase
  def setup
    @proj_wgs84   = Proj4::Projection.new(["init=epsg:4326"])       # WGS84
    @proj_gk    = Proj4::Projection.new(["init=epsg:31467"])      # Gauss-Kruger Zone 3
    @proj_conakry = Proj4::Projection.new(["init=epsg:31528"])      # Conakry 1905 / UTM zone 28N
    @proj_ortel   = Proj4::Projection.new(["proj=ortel", "lon_0=90w"])  # Ortelius Oval Projection
  end

  def test_has_inverse
    assert   @proj_wgs84.hasInverse?
    assert   @proj_gk.hasInverse?
    assert   @proj_conakry.hasInverse?
    assert ! @proj_ortel.hasInverse?
  end

  def test_is_latlong
    assert   @proj_wgs84.isLatLong?
    assert ! @proj_gk.isLatLong?
    assert ! @proj_conakry.isLatLong?
    assert ! @proj_ortel.isLatLong?
  end

  def test_is_geocent
    assert_equal @proj_gk.isGeocent?, @proj_gk.isGeocentric?  # two names for same method
    assert ! @proj_wgs84.isGeocent?
    assert ! @proj_gk.isGeocent?
    assert ! @proj_conakry.isGeocent?
    assert ! @proj_ortel.isGeocent?
  end

  def test_get_def
    assert_equal '+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0', @proj_wgs84.getDef.strip
    d = @proj_gk.getDef.strip
    assert ('+init=epsg:31467 +proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +ellps=bessel +datum=potsdam +units=m +no_defs +towgs84=606.0,23.0,413.0' == d || '+init=epsg:31467 +proj=tmerc +lat_0=0 +lon_0=9 +k=1.000000 +x_0=3500000 +y_0=0 +ellps=bessel +datum=potsdam +units=m +no_defs +towgs84=606.0,23.0,413.0' == d)
    assert_equal '+init=epsg:31528 +proj=utm +zone=28 +a=6378249.2 +b=6356515 +towgs84=-23,259,-9,0,0,0,0 +units=m +no_defs', @proj_conakry.getDef.strip
    assert_equal '+proj=ortel +lon_0=90w +ellps=WGS84', @proj_ortel.getDef.strip
  end

  def test_inspect
    assert_equal '#<Proj4::Projection +init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0>', @proj_wgs84.to_s
    assert_equal '#<Proj4::Projection +init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0>', @proj_wgs84.inspect
  end

  def test_projection
    assert_equal 'longlat', @proj_wgs84.projection
    assert_equal 'tmerc',   @proj_gk.projection
    assert_equal 'utm',   @proj_conakry.projection
    assert_equal 'ortel',   @proj_ortel.projection
  end

  def test_datum
    assert_equal 'WGS84',   @proj_wgs84.datum
    assert_equal 'potsdam', @proj_gk.datum
    assert_nil        @proj_conakry.datum
    assert_nil        @proj_ortel.datum
  end
end

