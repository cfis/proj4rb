# encoding: UTF-8

require_relative './abstract_test'

class TransformationTest < AbstractTest
  PRECISION = 0.5

  def setup
    @crs_wgs84 = Proj::Crs.new('epsg:4326')
    @crs_gk  = Proj::Crs.new('epsg:31467')
  end

  def test_create_from_strings
    transform = Proj::Transformation.new('epsg:31467', 'epsg:4326')
    assert(transform.info)
  end

  def test_create_crs
    transform = Proj::Transformation.new(@crs_wgs84, @crs_gk)
    assert(transform.info)
  end

  # echo "3458305 5428192" | cs2cs -f '%.10f' +init=epsg:31467 +to +init=epsg:4326 -
  def test_gk_to_wgs84_forward
    transform = Proj::Transformation.new(@crs_gk, @crs_wgs84)
    from = Proj::Coordinate.new(x: 5428192.0, y: 3458305.0, z: -5.1790915237)
    to = transform.forward(from)

    assert_in_delta(48.98963932450735, to.x, PRECISION)
    assert_in_delta(8.429263044355544, to.y, PRECISION)
    assert_in_delta(-5.1790915237, to.z, PRECISION)
    assert_in_delta(0, to.t, PRECISION)
  end

  def test_gk_to_wgs84_inverse
    transform = Proj::Transformation.new(@crs_gk, @crs_wgs84)
    from = Proj::Coordinate.new(lam: 48.9906726079, phi: 8.4302123334)
    to = transform.inverse(from)

    assert_in_delta(5428307, to.x, PRECISION)
    assert_in_delta(3458375, to.y, PRECISION)
    assert_in_delta(0, to.z, PRECISION)
    assert_in_delta(0, to.t, PRECISION)
  end

  # echo "8.4293092923 48.9896114523" | cs2cs -f '%.10f' +init=epsg:4326 +to +init=epsg:31467 -
  def test_wgs84_to_gk_forward
    transform = Proj::Transformation.new(@crs_wgs84, @crs_gk)
    from = Proj::Coordinate.new(lam: 48.9906726079, phi: 8.4302123334)
    to = transform.forward(from)

    assert_in_delta(5428307, to.x, PRECISION)
    assert_in_delta(3458375, to.y, PRECISION)
    assert_in_delta(0, to.z, PRECISION)
    assert_in_delta(0, to.t, PRECISION)
  end

  def test_wgs84_to_gk_forward_inverse
    transform = Proj::Transformation.new(@crs_wgs84, @crs_gk)
    from = Proj::Coordinate.new(x: 5428192.0, y: 3458305.0, z: -5.1790915237)
    to = transform.inverse(from)

    assert_in_delta(48.98963932450735, to.x, PRECISION)
    assert_in_delta(8.429263044355544, to.y, PRECISION)
    assert_in_delta(-5.1790915237, to.z, PRECISION)
    assert_in_delta(0, to.t, PRECISION)
  end
end