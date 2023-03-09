# encoding: UTF-8

require_relative './abstract_test'

class TransformationTest < AbstractTest
  PRECISION = 1.5

  def setup
    @crs_wgs84 = Proj::Crs.new('EPSG:4326')
    @crs_gk = Proj::Crs.new('EPSG:31467')
  end

  def test_create_from_strings
    transform = Proj::Transformation.new('EPSG:31467', 'EPSG:4326')
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
    puts transform.to_wkt
    from = Proj::Coordinate.new(lam: 48.9906726079, phi: 8.4302123334)
    to = transform.inverse(from)

    assert_in_delta(5428306, to.x, PRECISION)
    assert_in_delta(3458375, to.y, PRECISION)
    assert_in_delta(0, to.z, PRECISION)
    assert_in_delta(0, to.t, PRECISION)
  end

  # echo "8.4293092923 48.9896114523" | cs2cs -f '%.10f' +init=epsg:4326 +to +init=epsg:31467 -
  def test_wgs84_to_gk_forward
    transform = Proj::Transformation.new(@crs_wgs84, @crs_gk)
    from = Proj::Coordinate.new(lam: 48.9906726079, phi: 8.4302123334)
    to = transform.forward(from)

    assert_in_delta(5428306, to.x, PRECISION)
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

  def test_with_area
    area = Proj::Area.new(west_lon_degree: -114.1324, south_lat_degree: 49.5614,
                          east_lon_degree: 3.76488, north_lat_degree: 62.1463)
    transformation = Proj::Transformation.new("EPSG:4277", "EPSG:4326", area)

    coordinate1 = Proj::Coordinate.new(x: 50, y: -2, z: 0, t: Float::INFINITY)
    coordinate2 = transformation.forward(coordinate1)

    assert_in_delta(50.00065628, coordinate2.x, 1e-8)
    assert_in_delta(-2.00133989, coordinate2.y, 1e-8)
  end

  def test_accuracy_filter
    src = Proj::Crs.new("EPSG:4326")
    dst = Proj::Crs.new("EPSG:4258")

    error = assert_raises(Proj::Error) do
      Proj::Transformation.new(src, dst, accuracy: 0.05)
    end
    assert_equal("No operation found matching criteria", error.to_s)
  end

  def test_ballpark_filter
    src = Proj::Crs.new("EPSG:4267")
    dst = Proj::Crs.new("EPSG:4258")

    error = assert_raises(Proj::Error) do
      Proj::Transformation.new(src, dst, allow_ballpark: false)
    end
    assert_equal("No operation found matching criteria", error.to_s)
  end

  if proj8?
    def test_transform_bounds
      transform = Proj::Transformation.new("EPSG:4326",
                                           "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")

      start_bounds = Proj::Bounds.new(40, -120, 64, -80)
      end_bounds = transform.transform_bounds(start_bounds, :PJ_FWD, 0)

      assert_equal(-1684649.4133828662, end_bounds.xmin)
      assert_equal(-350356.8137658477, end_bounds.ymin)
      assert_equal(1684649.4133828674, end_bounds.xmax)
      assert_equal(2234551.1855909275, end_bounds.ymax)
    end

    def test_transform_bounds_normalized
      transform = Proj::Transformation.new("EPSG:4326",
                                           "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")

      normalized = transform.normalize_for_visualization

      start_bounds = Proj::Bounds.new(-120, 40, -80, 64)
      end_bounds = normalized.transform_bounds(start_bounds, :PJ_FWD, 100)

      assert_equal(-1684649.4133828662, end_bounds.xmin)
      assert_equal(-555777.7923351025, end_bounds.ymin)
      assert_equal(1684649.4133828674, end_bounds.xmax)
      assert_equal(2234551.1855909275, end_bounds.ymax)
    end

    def test_transform_bounds_densify
      transform = Proj::Transformation.new("EPSG:4326",
                                           "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")

      start_bounds = Proj::Bounds.new(40, -120, 64, -80)
      end_bounds = transform.transform_bounds(start_bounds, :PJ_FWD, 100)

      assert_equal(-1684649.4133828662, end_bounds.xmin)
      assert_equal(-555777.7923351025, end_bounds.ymin)
      assert_equal(1684649.4133828674, end_bounds.xmax)
      assert_equal(2234551.1855909275, end_bounds.ymax)
    end

    def test_instantiable
      operation = Proj::Conversion.create_from_database("EPSG", "1671", :PJ_CATEGORY_COORDINATE_OPERATION)
      assert(operation.instantiable?)
    end

    def test_steps_not_concatenated
      operation = Proj::Conversion.create_from_database("EPSG", "8048", :PJ_CATEGORY_COORDINATE_OPERATION)
      assert_instance_of(Proj::Transformation, operation)
      assert_equal(:PJ_TYPE_TRANSFORMATION, operation.proj_type)

      assert_equal(0, operation.step_count)
      refute(operation.step(0))
    end
  end
end