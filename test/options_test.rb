require_relative './abstract_test'

class OptionsTest < AbstractTest
  def test_builds_null_terminated_pointer_array
    options = Proj::Options.new("MULTILINE": "YES", "INDENTATION_WIDTH": 4)
    pointers = options.to_ptr.get_array_of_pointer(0, 3)

    refute(pointers[0].null?)
    refute(pointers[1].null?)
    assert(pointers[2].null?)
  end

  def test_empty_options_returns_null_pointer
    options = Proj::Options.new({})
    assert(options.to_ptr.null?)
  end
end
