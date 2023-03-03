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

  def test_version
    assert_instance_of(Gem::Version, Proj::Api::PROJ_VERSION)
    assert(Proj::Api::PROJ_VERSION.canonical_segments.first >= 5)
  end
end