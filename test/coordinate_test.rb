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
end