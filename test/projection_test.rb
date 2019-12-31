# encoding: UTF-8

require_relative './abstract_test'

class ProjectionTest < AbstractTest
  PRECISION = 0.1 ** 4
  
  def setup
    @proj_wgs84 = Proj::Projection.new(["init=epsg:4326"])       # WGS84
    @proj_gk = Proj::Projection.new(["+init=epsg:31467"])      # Gauss-Kruger Zone 3
    @proj_merc  = Proj::Projection.new(["proj=merc"])
    @proj_conakry = Proj::Projection.new(["+init=epsg:31528"])      # Conakry 1905 / UTM zone 28N
    @proj_ortel = Proj::Projection.new(["+proj=ortel", "+lon_0=90w"])  # Ortelius Oval Projection
    @epsg2029i = ['+init=epsg:2029']
    @epsg2029_args = ['+proj=utm', '+zone=17', '+ellps=clrk66', '+units=m', '+no_defs']
  end

  def test_arg_fail
    assert_raises ArgumentError do
      Proj::Projection.parse()
    end
    assert_raises ArgumentError do
      Proj::Projection.parse(nil)
    end
    assert_raises ArgumentError do
      Proj::Projection.parse(1)
    end
  end

  def test_arg_string
    args = Proj::Projection.parse('+init=epsg:2029')
    assert_equal(@epsg2029i, args)
    args = Proj::Projection.parse('  +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs  ')
    assert_equal(@epsg2029_args, args)
  end

  def test_arg_string_with_plus
    args = Proj::Projection.parse('+init=epsg:2029')
    assert_equal(@epsg2029i, args)
    args = Proj::Projection.parse('+proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs')
    assert_equal(@epsg2029_args, args)
  end

  def test_arg_array
    args = Proj::Projection.parse(['+init=epsg:2029'])
    assert_equal(@epsg2029i, args)
    args = Proj::Projection.parse(['+proj=utm', '+zone=17', '+ellps=clrk66', '+units=m', '+no_defs'])
    assert_equal(@epsg2029_args, args)
  end

  def test_arg_array_with_plus
    args = Proj::Projection.parse(['+init=epsg:2029'])
    assert_equal(@epsg2029i, args)
    args = Proj::Projection.parse(['+proj=utm', '+zone=17', '+ellps=clrk66', '+units=m', '+no_defs'])
    assert_equal(@epsg2029_args, args)
  end

  def test_arg_hash_with_string
    args = Proj::Projection.parse('init' => 'epsg:2029')
    assert_equal(@epsg2029i, args)
    args = Proj::Projection.parse('proj' => 'utm', 'zone' => '17', 'ellps' => 'clrk66', 'units' => 'm', 'no_defs' => nil)
    assert_equal(@epsg2029_args, args)
  end

  def test_arg_hash_with_symbol
    args = Proj::Projection.parse(:init => 'epsg:2029')
    assert_equal(@epsg2029i, args)
    args = Proj::Projection.parse(:proj => 'utm', :zone => '17', :ellps => 'clrk66', :units => 'm', :no_defs => nil)
    assert_equal(@epsg2029_args, args)
  end

  def test_arg_hash_with_symbol_simple
    args = Proj::Projection.parse(:init => 'epsg:2029')
    assert_equal(@epsg2029i, args)
    args = Proj::Projection.parse(:proj => 'utm', :zone => '17', :ellps => 'clrk66', :units => 'm', :no_defs => nil)
    assert_equal(@epsg2029_args, args)
  end

  def test_arg_projection
    proj = Proj::Projection.new(['+init=epsg:2029'])
    args = Proj::Projection.parse(proj)
    assert_equal(["+init=epsg:2029", "+proj=utm", "+zone=17", "+ellps=clrk66", "+units=m", "+no_defs"], args)
  end

  def test_init_arg_string
    proj = Proj::Projection.new('+init=epsg:2029')
    assert_equal(' +init=epsg:2029 +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs', proj.getDef)
  end

  def test_init_arg_array
    proj = Proj::Projection.new(['+init=epsg:2029'])
    assert_equal(' +init=epsg:2029 +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs', proj.getDef)
  end

  def test_init_arg_hash
    proj = Proj::Projection.new(:proj => 'utm', 'zone' => '17', 'ellps' => 'clrk66', :units => 'm', :no_defs => nil)
    assert_equal(' +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs', proj.getDef)
  end

  def test_init_arg_fail
    assert_raises Proj::Error do
      Proj::Projection.new(:proj => 'xxxx')
    end

    assert_raises Proj::Error do
      Proj::Projection.new(:foo => 'xxxx')
    end
  end

  def test_is_latlong
    assert(@proj_wgs84.isLatLong?)
    refute(@proj_gk.isLatLong?)
    refute(@proj_conakry.isLatLong?)
    refute(@proj_ortel.isLatLong?)
  end

  def test_is_geocent
    assert_equal(@proj_gk.isGeocent?, @proj_gk.isGeocentric?)  # two names for same method
    refute(@proj_wgs84.isGeocent?)
    refute(@proj_gk.isGeocent?)
    refute(@proj_conakry.isGeocent?)
    refute(@proj_ortel.isGeocent?)
  end

  def test_get_def
    assert_equal(' +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0', @proj_wgs84.getDef)
    assert_equal(' +init=epsg:31467 +proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +ellps=bessel +units=m +no_defs', @proj_gk.getDef)
    assert_equal('+proj=ortel +lon_0=90w +ellps=GRS80', @proj_ortel.getDef.strip)
  end

  def test_to_s
    assert_equal('#<Proj::Projection +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0>', @proj_wgs84.to_s)
  end

  def test_projection
    assert_equal('longlat', @proj_wgs84.projection)
    assert_equal('tmerc', @proj_gk.projection)
    assert_equal('utm', @proj_conakry.projection)
    assert_equal('ortel', @proj_ortel.projection)
  end

  def test_datum
    assert_equal('WGS84', @proj_wgs84.datum)
    assert_nil(@proj_gk.datum)
    assert_nil(@proj_conakry.datum)
  end

  # echo "8.4302123334 48.9906726079" | proj +init=epsg:31467 -
  def test_forward_gk
    point = Proj::Point.new(8.4302123334, 48.9906726079)
    result = @proj_gk.forward(point.to_radians)
    assert_in_delta(3458305.0, result.x, 0.1)
    assert_in_delta(5428192.0, result.y, 0.1)
  end

  def test_forward_gk_degrees
    point = Proj::Point.new(8.4302123334, 48.9906726079)
    result = @proj_gk.forwardDeg(point)
    assert_in_delta(3458305.0, result.x, 0.1)
    assert_in_delta(5428192.0, result.y, 0.1)
  end

  # echo "3458305 5428192" | invproj -f '%.10f' +init=epsg:31467 -
  def test_inverse_gk
    point = Proj::Point.new(3458305.0, 5428192.0)
    result = @proj_gk.inverse(point).to_degrees
    assert_in_delta(result.x, 8.4302123334, PRECISION)
    assert_in_delta(result.y, 48.9906726079, PRECISION)
  end

  def test_inverse_gk_degrees
    point = Proj::Point.new(3458305.0, 5428192.0)
    result = @proj_gk.inverseDeg(point)
    assert_in_delta(result.x, 8.4302123334, PRECISION)
    assert_in_delta(result.y, 48.9906726079, PRECISION)
  end

  # echo "190 92" | proj +init=epsg:31467 -
  def test_out_of_bounds
    error = assert_raises(Proj::Error) do
      point = Proj::Point.new(190, 92).to_radians
      @proj_gk.forward(point)
    end
    assert_equal('latitude or longitude exceeded limits', error.message)
  end

  # echo "3458305 5428192" | cs2cs -f '%.10f' +init=epsg:31467 +to +init=epsg:4326 -
  def test_gk_to_wgs84
    from = Proj::Point.new(3458305.0, 5428192.0)
    to = @proj_gk.transform(@proj_wgs84, from).to_degrees
    assert_in_delta(8.4302123334, to.x, PRECISION)
    assert_in_delta(48.9906726079, to.y, PRECISION)
  end

  # echo "8.4293092923 48.9896114523" | cs2cs -f '%.10f' +init=epsg:4326 +to +init=epsg:31467 -
  def test_wgs84_to_gk
    from = Proj::Point.new(8.4302123334, 48.9906726079)
    to = @proj_wgs84.transform(@proj_gk, from.to_radians)
    assert_in_delta(3458305.0, to.x, PRECISION)
    assert_in_delta(5428192.0, to.y, PRECISION)
  end

  def test_mercator_at_pole_raise
    from = Proj::Point.new(0, 90)
    assert_raises(Proj::Error) do
      @proj_wgs84.transform(@proj_merc, from.to_radians)
    end
  end

  def test_collection
    from0 = Proj::Point.new(3458305.0, 5428192.0)
    from1 = Proj::Point.new(0, 0)
    collection = @proj_gk.transform_all(@proj_wgs84, [from0, from1])

    to0 = collection[0].to_degrees
    to1 = collection[1].to_degrees

    assert_in_delta(8.4302123334, to0.x, PRECISION)
    assert_in_delta(48.9906726079, to0.y, PRECISION)

    assert_in_delta(-20.9657785647, to1.x, PRECISION)
    assert_in_delta(0, to1.y, PRECISION)
  end
end