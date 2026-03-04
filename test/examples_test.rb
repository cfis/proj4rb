require_relative 'abstract_test'

class ExamplesTest < AbstractTest
  def test_geodetic_distance
    crs = Proj::Crs.new('EPSG:4326')

    paris  = Proj::Coordinate.new(x: Proj.degrees_to_radians(2.3522),
                                   y: Proj.degrees_to_radians(48.8566))
    berlin = Proj::Coordinate.new(x: Proj.degrees_to_radians(13.4050),
                                   y: Proj.degrees_to_radians(52.5200))

    distance = crs.lp_distance(paris, berlin)
    assert_in_delta(879_700, distance, 5_000)
  end

  def test_geod_distance_with_azimuth
    crs = Proj::Crs.new('EPSG:4326')

    paris  = Proj::Coordinate.new(x: Proj.degrees_to_radians(2.3522),
                                   y: Proj.degrees_to_radians(48.8566))
    berlin = Proj::Coordinate.new(x: Proj.degrees_to_radians(13.4050),
                                   y: Proj.degrees_to_radians(52.5200))

    result = crs.geod_distance(paris, berlin)
    assert_in_delta(879_700, result.x, 5_000)
    # Forward azimuth: roughly northeast
    assert_in_delta(58.24, result.y, 1.0)
    # Reverse azimuth: roughly southwest
    assert_in_delta(66.81, result.z, 1.0)
  end

  if Proj::Api::PROJ_VERSION >= Gem::Version.new('9.7.0')
    def test_geod_direct
      crs = Proj::Crs.new('EPSG:4326')

      paris = Proj::Coordinate.new(x: Proj.degrees_to_radians(2.3522),
                                    y: Proj.degrees_to_radians(48.8566))

      # 100 km due north
      endpoint = crs.geod_direct(paris, 0.0, 100_000)
      assert(endpoint.x.finite?)
      assert(endpoint.y.finite?)
      # Longitude should be approximately the same
      assert_in_delta(2.3522, Proj.radians_to_degrees(endpoint.x), 0.01)
      # Latitude should be ~0.9 degrees further north
      assert_in_delta(49.76, Proj.radians_to_degrees(endpoint.y), 0.1)
    end
  end

  def test_transform_bounds
    transform = Proj::Transformation.new('EPSG:4326',
      '+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs')

    bounds = Proj::Bounds.new(40, -120, 64, -80)
    result = transform.transform_bounds(bounds, :PJ_FWD, 21)

    assert(result.xmin.finite?)
    assert(result.ymin.finite?)
    assert(result.xmax.finite?)
    assert(result.ymax.finite?)
    assert_operator(result.xmin, :<, result.xmax)
    assert_operator(result.ymin, :<, result.ymax)
  end

  def test_database_query_authorities
    database = Proj::Database.new(Proj::Context.current)
    authorities = database.authorities
    assert_operator(authorities.count, :>, 0)
    assert_includes(authorities.to_a, 'EPSG')
  end

  def test_database_query_codes
    database = Proj::Database.new(Proj::Context.current)
    codes = database.codes('EPSG', :PJ_TYPE_GEOGRAPHIC_2D_CRS)
    assert_operator(codes.count, :>, 0)
  end

  def test_database_query_crs_info
    database = Proj::Database.new(Proj::Context.current)
    crs_infos = database.crs_info('EPSG')
    assert_operator(crs_infos.count, :>, 0)

    info = crs_infos.first
    assert_equal('EPSG', info.auth_name)
    refute_nil(info.name)
    refute_nil(info.crs_type)
  end

  def test_crs_identification
    crs = Proj::Crs.new('OGC:CRS84')
    objects, confidences = crs.identify('OGC')

    assert_equal(1, objects.count)
    assert_equal(100, confidences[0])
  end

  def test_promote_to_3d
    crs_2d = Proj::Crs.new('EPSG:4326')
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs_2d.proj_type)

    crs_3d = crs_2d.promote_to_3d
    assert_equal(:PJ_TYPE_GEOGRAPHIC_3D_CRS, crs_3d.proj_type)
  end

  def test_demote_to_2d
    crs_2d = Proj::Crs.new('EPSG:4326')
    crs_3d = crs_2d.promote_to_3d
    crs_back = crs_3d.demote_to_2d
    assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, crs_back.proj_type)
  end

  def test_batch_transformation
    conversion = Proj::Conversion.new('+proj=utm +zone=32 +ellps=GRS80')

    coordinates = [
      Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(55), z: 45),
      Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(56), z: 50),
      Proj::Coordinate.new(lon: Proj.degrees_to_radians(13), lat: Proj.degrees_to_radians(55), z: 30)
    ]

    results = conversion.transform_array(coordinates, :PJ_FWD)

    assert_equal(3, results.size)
    results.each do |coord|
      assert(coord.x.finite?)
      assert(coord.y.finite?)
    end

    assert_in_delta(691875.63, results[0].x, 1)
    assert_in_delta(6098907.83, results[0].y, 1)
  end

  def test_context_logging
    context = Proj::Context.new
    messages = []

    context.set_log_function do |_pointer, level, message|
      messages << { level: level, message: message }
    end

    begin
      context.database.path = '/nonexistent'
    rescue Proj::Error
    end

    refute_empty(messages)
    assert(messages.any? { |m| m[:message].include?('/nonexistent') })
  end
end
