# encoding: UTF-8

require_relative './abstract_test'

class CoordinateTest < AbstractTest
  def test_create_xyzt
    coord = Proj::Coordinate.new(:x => 1, :y => 2, :z => 3, :t => 4)
    assert_equal('v0: 1.0, v1: 2.0, v2: 3.0, v3: 4.0', coord.to_s)
  end

  def test_create_uvwt
    coord = Proj::Coordinate.new(:u => 5, :v => 6, :w => 7, :t => 8)
    assert_equal('v0: 5.0, v1: 6.0, v2: 7.0, v3: 8.0', coord.to_s)
  end

  def test_create_lpzt
    coord = Proj::Coordinate.new(:lam => 9, :phi => 10, :z => 11, :t => 12)
    assert_equal('v0: 9.0, v1: 10.0, v2: 11.0, v3: 12.0', coord.to_s)
  end

  def test_create_geod
    coord = Proj::Coordinate.new(:s => 13, :a1 => 14, :a2 => 15)
    assert_equal('v0: 13.0, v1: 14.0, v2: 15.0, v3: 0.0', coord.to_s)
  end

  def test_create_opk
    coord = Proj::Coordinate.new(:o => 16, :p => 17, :k => 18)
    assert_equal('v0: 16.0, v1: 17.0, v2: 18.0, v3: 0.0', coord.to_s)
  end

  def test_create_enu
    coord = Proj::Coordinate.new(:e => 19, :n => 20, :u => 21)
    assert_equal('v0: 19.0, v1: 20.0, v2: 21.0, v3: 0.0', coord.to_s)
  end

  def test_eql
    coord1 = Proj::Coordinate.new(x: 1, y: 2, z: 3, t: 4)
    coord2 = Proj::Coordinate.new(x: 1, y: 2, z: 3, t: 4)
    assert(coord1.eql?(coord2))
  end

  def test_eql_different
    coord1 = Proj::Coordinate.new(x: 1, y: 2)
    coord2 = Proj::Coordinate.new(x: 1, y: 3)
    refute(coord1.eql?(coord2))
  end

  def test_eql_non_coordinate
    coord = Proj::Coordinate.new(x: 1, y: 2)
    refute(coord.eql?("not a coordinate"))
  end

  def test_equal
    coord1 = Proj::Coordinate.new(x: 1, y: 2, z: 3, t: 4)
    coord2 = Proj::Coordinate.new(x: 1, y: 2, z: 3, t: 4)
    assert_equal(coord1, coord2)
  end

  def test_not_equal
    coord1 = Proj::Coordinate.new(x: 1, y: 2)
    coord2 = Proj::Coordinate.new(x: 1, y: 3)
    refute_equal(coord1, coord2)
  end

  def test_equal_non_coordinate
    coord = Proj::Coordinate.new(x: 1, y: 2)
    refute_equal(coord, "not a coordinate")
  end

  def test_xyzt_accessor
    coord = Proj::Coordinate.new(x: 1, y: 2, z: 3, t: 4)
    xyzt = coord.xyzt
    assert_equal(1.0, xyzt[:x])
    assert_equal(2.0, xyzt[:y])
    assert_equal(3.0, xyzt[:z])
    assert_equal(4.0, xyzt[:t])
  end

  def test_xyz_accessor
    coord = Proj::Coordinate.new(x: 1, y: 2, z: 3)
    xyz = coord.xyz
    assert_equal(1.0, xyz[:x])
    assert_equal(2.0, xyz[:y])
    assert_equal(3.0, xyz[:z])
  end

  def test_xy_accessor
    coord = Proj::Coordinate.new(x: 1, y: 2)
    xy = coord.xy
    assert_equal(1.0, xy[:x])
    assert_equal(2.0, xy[:y])
  end

  def test_uvwt_accessor
    coord = Proj::Coordinate.new(u: 5, v: 6, w: 7, t: 8)
    uvwt = coord.uvwt
    assert_equal(5.0, uvwt[:u])
    assert_equal(6.0, uvwt[:v])
    assert_equal(7.0, uvwt[:w])
    assert_equal(8.0, uvwt[:t])
  end

  def test_uvw_accessor
    coord = Proj::Coordinate.new(u: 5, v: 6, w: 7)
    uvw = coord.uvw
    assert_equal(5.0, uvw[:u])
    assert_equal(6.0, uvw[:v])
    assert_equal(7.0, uvw[:w])
  end

  def test_uv_accessor
    coord = Proj::Coordinate.new(u: 5, v: 6)
    uv = coord.uv
    assert_equal(5.0, uv[:u])
    assert_equal(6.0, uv[:v])
  end

  def test_lpzt_accessor
    coord = Proj::Coordinate.new(lam: 9, phi: 10, z: 11, t: 12)
    lpzt = coord.lpzt
    assert_equal(9.0, lpzt[:lam])
    assert_equal(10.0, lpzt[:phi])
    assert_equal(11.0, lpzt[:z])
    assert_equal(12.0, lpzt[:t])
  end

  def test_lpz_accessor
    coord = Proj::Coordinate.new(lam: 9, phi: 10, z: 11)
    lpz = coord.lpz
    assert_equal(9.0, lpz[:lam])
    assert_equal(10.0, lpz[:phi])
    assert_equal(11.0, lpz[:z])
  end

  def test_lp_accessor
    coord = Proj::Coordinate.new(lam: 9, phi: 10)
    lp = coord.lp
    assert_equal(9.0, lp[:lam])
    assert_equal(10.0, lp[:phi])
  end

  def test_enu_accessor
    coord = Proj::Coordinate.new(e: 19, n: 20, u: 21)
    enu = coord.enu
    assert_equal(19.0, enu[:e])
    assert_equal(20.0, enu[:n])
    assert_equal(21.0, enu[:u])
  end

  def test_geod_accessor
    coord = Proj::Coordinate.new(s: 13, a1: 14, a2: 15)
    geod = coord.geod
    assert_equal(13.0, geod[:s])
    assert_equal(14.0, geod[:a1])
    assert_equal(15.0, geod[:a2])
  end

  def test_opk_accessor
    coord = Proj::Coordinate.new(o: 16, p: 17, k: 18)
    opk = coord.opk
    assert_equal(16.0, opk[:o])
    assert_equal(17.0, opk[:p])
    assert_equal(18.0, opk[:k])
  end

  # Constructor branch coverage

  def test_create_xyz
    coord = Proj::Coordinate.new(x: 1, y: 2, z: 3)
    assert_equal(1.0, coord.x)
    assert_equal(2.0, coord.y)
    assert_equal(3.0, coord.z)
    assert_equal(0.0, coord.t)
  end

  def test_create_xy
    coord = Proj::Coordinate.new(x: 1, y: 2)
    assert_equal(1.0, coord.x)
    assert_equal(2.0, coord.y)
  end

  def test_create_uv
    coord = Proj::Coordinate.new(u: 5, v: 6)
    assert_equal(5.0, coord.u)
    assert_equal(6.0, coord.v)
  end

  def test_create_uvw
    coord = Proj::Coordinate.new(u: 5, v: 6, w: 7)
    assert_equal(5.0, coord.u)
    assert_equal(6.0, coord.v)
    assert_equal(7.0, coord.w)
  end

  def test_create_lp
    coord = Proj::Coordinate.new(lam: 9, phi: 10)
    assert_equal(9.0, coord.lam)
    assert_equal(10.0, coord.phi)
  end

  def test_create_lpz
    coord = Proj::Coordinate.new(lam: 9, phi: 10, z: 11)
    assert_equal(9.0, coord.lam)
    assert_equal(10.0, coord.phi)
    assert_equal(11.0, coord.z)
  end

  def test_create_lonlat
    coord = Proj::Coordinate.new(lon: 9, lat: 10)
    assert_equal(9.0, coord.lon)
    assert_equal(10.0, coord.lat)
  end

  def test_create_lonlatz
    coord = Proj::Coordinate.new(lon: 9, lat: 10, z: 11)
    assert_equal(9.0, coord.lon)
    assert_equal(10.0, coord.lat)
    assert_equal(11.0, coord.z)
  end

  def test_create_lonlatzt
    coord = Proj::Coordinate.new(lon: 9, lat: 10, z: 11, t: 12)
    assert_equal(9.0, coord.lon)
    assert_equal(10.0, coord.lat)
    assert_equal(11.0, coord.z)
    assert_equal(12.0, coord.t)
  end

  def test_create_empty
    coord = Proj::Coordinate.new
    assert_equal(0.0, coord.x)
    assert_equal(0.0, coord.y)
    assert_equal(0.0, coord.z)
    assert_equal(0.0, coord.t)
  end

  # Individual value accessors

  def test_xyzt_values
    coord = Proj::Coordinate.new(x: 1, y: 2, z: 3, t: 4)
    assert_equal(1.0, coord.x)
    assert_equal(2.0, coord.y)
    assert_equal(3.0, coord.z)
    assert_equal(4.0, coord.t)
  end

  def test_uvw_values
    coord = Proj::Coordinate.new(u: 5, v: 6, w: 7)
    assert_equal(5.0, coord.u)
    assert_equal(6.0, coord.v)
    assert_equal(7.0, coord.w)
  end

  def test_lonlat_values
    coord = Proj::Coordinate.new(lon: 9, lat: 10)
    assert_equal(9.0, coord.lon)
    assert_equal(10.0, coord.lat)
  end

  def test_lamphi_values
    coord = Proj::Coordinate.new(lam: 9, phi: 10)
    assert_equal(9.0, coord.lam)
    assert_equal(10.0, coord.phi)
  end

  def test_opk_values
    coord = Proj::Coordinate.new(o: 16, p: 17, k: 18)
    assert_equal(16.0, coord.o)
    assert_equal(17.0, coord.p)
    assert_equal(18.0, coord.k)
  end

  def test_enu_values
    coord = Proj::Coordinate.new(e: 19, n: 20, u: 21)
    assert_equal(19.0, coord.e)
    assert_equal(20.0, coord.n)
  end

  def test_geod_values
    coord = Proj::Coordinate.new(s: 13, a1: 14, a2: 15)
    assert_equal(13.0, coord.s)
    assert_equal(14.0, coord.a1)
    assert_equal(15.0, coord.a2)
  end

  def test_to_s
    coord = Proj::Coordinate.new(x: 1, y: 2, z: 3, t: 4)
    assert_equal("v0: 1.0, v1: 2.0, v2: 3.0, v3: 4.0", coord.to_s)
  end
end