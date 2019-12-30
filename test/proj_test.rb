# encoding: UTF-8

require_relative './abstract_test'

class ProjTest < AbstractTest
  def test_info
    info = Proj.info
    assert_equal(6, info[:major])
    assert_equal(2, info[:minor])
    assert_equal(1, info[:patch])
    assert_equal('Rel. 6.2.1, November 1st, 2019', info[:release])
    assert_equal('6.2.1', info[:version])
    refute_nil(info[:searchpath])
    assert(info[:paths].null?)
    assert_equal(0, info[:path_count])
  end
end