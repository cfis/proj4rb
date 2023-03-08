# encoding: UTF-8

require_relative './abstract_test'

class ProjTest < AbstractTest
  def test_info
    info = Proj.info
    assert([4,6,7,8,9].include?(info[:major]))
    assert([0,1,2,3].include?(info[:minor]))
    assert([0,1,2,3].include?(info[:patch]))
    refute_nil(info[:release])
    refute_nil(info[:searchpath])
    assert(info[:paths].null?)
    assert(0, info[:path_count])
  end

  def test_search_paths
    search_paths = Proj.search_paths
    assert_instance_of(Array, search_paths)
    refute(search_paths.empty?)
  end

  def test_init_file_info
    info = Proj.init_file_info("EPSG")
    assert_equal("EPSG", info[:name].to_ptr.read_string)
    assert(info[:filename].to_ptr.read_string.empty?)
    #assert_equal("epsg", info[:version].to_ptr.read_string)
    assert_equal("", info[:origin].to_ptr.read_string)
    assert_equal("", info[:lastupdate].to_ptr.read_string)
  end

  def test_version
    assert_instance_of(Gem::Version, Proj::Api::PROJ_VERSION)
    assert(Proj::Api::PROJ_VERSION.canonical_segments.first >= 5)
  end

  def test_degrees_to_radians
    radians = Proj.degrees_to_radians(180)
    assert_equal(Math::PI, radians)
  end

  def test_radians_to_degrees
    degrees = Proj.radians_to_degrees(-Math::PI)
    assert_equal(-180, degrees)
  end

  def test_degrees_minutes_seconds_to_radians
    value = "19°46'27\"E"
    radians = Proj.degrees_minutes_seconds_to_radians(value)
    assert_in_delta(0.34512432, radians, 1e-7)
  end

  def test_radians_to_degrees_minutes_seconds
    result = Proj.radians_to_degrees_minutes_seconds(Math::PI)
    assert_equal("180dN", result)
  end
end