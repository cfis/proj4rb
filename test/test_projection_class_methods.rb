$: << 'lib'
require File.join(File.dirname(__FILE__), '..', 'lib', 'proj4')
require 'test/unit'

class ProjectionClassMethodsTest < Test::Unit::TestCase

    def test_units
        all_units = %w{km m dm cm mm kmi in ft yd mi fath ch link us-in us-ft us-yd us-ch us-mi ind-yd ind-ft ind-ch}.sort
        units = Proj4::Projection.listUnits.sort
        assert_equal all_units, units
    end

end
