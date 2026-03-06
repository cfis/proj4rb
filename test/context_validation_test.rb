require_relative './abstract_test'

class ContextValidationTest < AbstractTest
  def test_create_engineering_requires_proj_context
    error = assert_raises(TypeError) do
      Proj::Crs.create_engineering("EPSG", name: "4807")
    end

    assert_equal("expected Proj::Context, got String", error.message)
  end
end
