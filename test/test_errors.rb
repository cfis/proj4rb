# encoding: UTF-8

require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class ErrorsTest < Test::Unit::TestCase

  def test_list
    assert_equal "Unknown",       Proj4::Error.error(0)
    assert_equal "NoOptionsInInitFile", Proj4::Error.error(2)
    assert_equal "NoOptionsInInitFile", Proj4::Error.error(-2)
    assert_equal "Unknown",       Proj4::Error.error(-2000)
  end

  def test_parenting
    assert_kind_of Proj4::Error,  Proj4::UnknownError.new
    assert_kind_of Proj4::Error,  Proj4::ToleranceConditionError.new
    assert_kind_of StandardError, Proj4::UnknownError.new
  end

  def test_num
    assert 0, Proj4::UnknownError.errnum
    assert 1, Proj4::NoArgsInInitListError.errnum
  end

  def test_raise
    assert_raise Proj4::UnknownError do
      Proj4::Error.raise_error(0)
    end
    assert_raise Proj4::NoOptionsInInitFileError do
      Proj4::Error.raise_error(2)
    end
    assert_raise Proj4::ProjectionNotNamedError do
      Proj4::Error.raise_error(-4)
    end
    assert_raise Proj4::UnknownError do
      Proj4::Error.raise_error(2000)
    end
  end

  def test_strerrno
    assert_equal 'no arguments in initialization list', Proj4::Error.message(-1)
    assert_equal 'reciprocal flattening (1/f) = 0',   Proj4::Error.message(-10)
    assert_equal 'unknown error',             Proj4::Error.message(0)
    assert_match /^invalid projection system error/,  Proj4::Error.message(-2000)
  end

  def test_raise_err0
    exception = assert_raise(Proj4::UnknownError) do
      Proj4::Error.raise_error(0)
    end
    assert_equal "unknown error", exception.message
    assert_equal 0, exception.errnum
    assert_match %r{test/test_errors.rb:[0-9]+:in .test_raise_err0.$} , exception.backtrace[0]
  end

  def test_raise_err1
    exception = assert_raise(Proj4::NoArgsInInitListError) do
      Proj4::Error.raise_error(1)
    end
    assert_equal 'no arguments in initialization list', exception.message
    assert_equal 1, exception.errnum
    assert_match %r{test/test_errors.rb:[0-9]+:in .test_raise_err1.$} , exception.backtrace[0]
  end
end

