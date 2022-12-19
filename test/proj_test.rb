# encoding: UTF-8

require_relative './abstract_test'

class ProjTest < AbstractTest
  def test_info
    info = Proj.info
    assert([4,6,7,8,9].include?(info[:major]))
    assert([0,1,2,3].include?(info[:minor]))
    assert([0,1,2,3].include?(info[:patch]))
    refute_nil(info[:release])
    assert_match(/\d\.\d\.\d/, info[:version])
    refute_nil(info[:searchpath])
    refute(info[:paths].null?)
    assert_equal(1, info[:path_count])
  end
end