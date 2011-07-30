# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class ConstantsTest < Test::Unit::TestCase
  def test_version
    assert 440 < Proj4::LIBVERSION
  end

  def test_deg
    assert_equal Math::PI/180, Proj4::DEG_TO_RAD
  end

  def test_rad
    assert_equal 180/Math::PI, Proj4::RAD_TO_DEG
  end
end