# encoding: UTF-8

require_relative './abstract_test'

class ContextTest < AbstractTest
  def test_create
    context = Proj::Context.new
    assert(context.to_ptr)
  end

  def test_finalize
    500.times do
      context = Proj::Context.new
      assert(context.to_ptr)
      GC.start
    end
    assert(true)
  end

  def test_one_per_thread
    context_1 = Proj::Context.current
    context_2 = Proj::Context.current
    assert_same(context_1, context_2)
  end

  def test_database_path
    refute_nil(Proj::Context.current.database_path)
  end

  def test_log_level
    assert_equal(:PJ_LOG_NONE, Proj::Context.current.log_level)
  end

  def test_set_log_level
    context = Proj::Context.new
    context.log_level = :PJ_LOG_ERROR
    assert_equal(:PJ_LOG_ERROR, context.log_level)
  end

  def test_invalid_database_path
    path = '/wrong'
    error = assert_raises(Proj::Error) do
      Proj::Context.current.database_path = path
    end
    # TODO - if you run this test on its own you get a useful error message, if you run all tests
    # at once you get a useless error message. Not sure what is causing the difference
    assert_match(/No such file or directory|generic error of unknown origin/, error.to_s)
  end

  def test_set_log_function
    context = Proj::Context.new
    called = false

    data = FFI::MemoryPointer.new(:int)
    data.write_int(5)

    context.set_log_function(data) do |pointer, int, message|
      called = true
      refute(pointer.null?)
      assert_equal(5, pointer.read_int)
      assert_equal(1, int)
      assert_equal('proj_context_set_database_path: Open of /wrong failed', message)
    end

    begin
      context.database_path = '/wrong'
    rescue
    end

    assert(called)
  end

  def test_use_proj4_init_rules
    refute(Proj::Context.current.use_proj4_init_rules)

    Proj::Context.current.use_proj4_init_rules = true
    assert(Proj::Context.current.use_proj4_init_rules)

    Proj::Context.current.use_proj4_init_rules = false
    refute(Proj::Context.current.use_proj4_init_rules)
  end
end