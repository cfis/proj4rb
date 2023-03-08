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
end