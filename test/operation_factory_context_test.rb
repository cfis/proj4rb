# encoding: UTF-8

require_relative './abstract_test'

class OperationFactoryContextTest < AbstractTest
  def test_create
    context = Proj::OperationFactoryContext.new
    assert(context.to_ptr)
  end

  def test_finalize
    5.times do
      context = Proj::OperationFactoryContext.new
      assert(context.to_ptr)
      GC.start
    end
    assert(true)
  end

  def test_create_operations
    source = Proj::Crs.create_from_database("EPSG", "4267", :PJ_CATEGORY_CRS)
    target = Proj::Crs.create_from_database("EPSG", "4269", :PJ_CATEGORY_CRS)

    factory_context = Proj::OperationFactoryContext.new
    factory_context.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
    factory_context.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

    operations = factory_context.create_operations(source, target)
    assert_equal(10, operations.count)

    operation = operations[0]
    assert_equal("NAD27 to NAD83 (4)", operation.name)
    refute(operation.ballpark_transformation?)
  end

  def test_suggested_operation
    source = Proj::Crs.create_from_database("EPSG", "4267", :PJ_CATEGORY_CRS)
    target = Proj::Crs.create_from_database("EPSG", "4269", :PJ_CATEGORY_CRS)

    factory_context = Proj::OperationFactoryContext.new
    factory_context.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
    factory_context.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

    operations = factory_context.create_operations(source, target)

    coord = Proj::Coordinate.new(x: 40, y: -100)
    index = operations.suggested_operation(:PJ_FWD, coord)

    expected = case
               when proj8?
                 7
               else
                 2
               end
    assert_equal(expected, index)

    operation = operations[index]
    assert_equal("NAD27 to NAD83 (1)", operation.name)
  end

  def test_ballpark_transformations
    source = Proj::Crs.create_from_database("EPSG", "4267", :PJ_CATEGORY_CRS)
    target = Proj::Crs.create_from_database("EPSG", "4258", :PJ_CATEGORY_CRS)

    factory_context = Proj::OperationFactoryContext.new
    factory_context.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
    factory_context.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

    # Allowed implicitly
    operations = factory_context.create_operations(source, target)
    assert_equal(1, operations.count)

    # Allow explicitly
    factory_context.ballpark_transformations = true
    operations = factory_context.create_operations(source, target)
    assert_equal(1, operations.count)

    # Disallow
    factory_context.ballpark_transformations = false
    operations = factory_context.create_operations(source, target)
    assert_equal(0, operations.count)
  end

  def test_desired_accuracy
    context = Proj::OperationFactoryContext.new
    context.desired_accuracy = 5
  end

  def test_set_area_of_interest
    context = Proj::OperationFactoryContext.new
    context.set_area_of_interest(10, 10, 10, 10)
  end

  def test_set_area_of_interest_name
    context = Proj::OperationFactoryContext.new
    context.area_of_interest_name = 'test'
  end

  def test_crs_extent_use
    context = Proj::OperationFactoryContext.new
    context.crs_extent_use = :PJ_CRS_EXTENT_SMALLEST
  end

  def test_spatial_criterion
    context = Proj::OperationFactoryContext.new
    context.spatial_criterion = :PROJ_SPATIAL_CRITERION_STRICT_CONTAINMENT
  end

  def test_grid_availability
    context = Proj::OperationFactoryContext.new
    context.grid_availability = :PROJ_GRID_AVAILABILITY_USE
  end

  def test_use_proj_alternative_grid_names
    context = Proj::OperationFactoryContext.new
    context.use_proj_alternative_grid_names = true
  end

  def test_allow_use_intermediate_crs
    # There is no direct transformations between both
    source = Proj::Crs.create_from_database("EPSG", "4230", :PJ_CATEGORY_CRS)
    target = Proj::Crs.create_from_database("EPSG", "4171", :PJ_CATEGORY_CRS)

    # Default behavior: allow any pivot
    factory_context = Proj::OperationFactoryContext.new
    operations = factory_context.create_operations(source, target)
    assert_equal(1, operations.count)

    operation = operations[0]
    assert_equal("ED50 to ETRS89 (10) + Inverse of RGF93 v1 to ETRS89 (1)", operation.name)
    refute(operation.ballpark_transformation?)

    # Disallow pivots
    factory_context.allow_use_intermediate_crs = :PROJ_INTERMEDIATE_CRS_USE_NEVER
    operations = factory_context.create_operations(source, target)
    assert_equal(1, operations.count)

    operation = operations[0]
    assert_equal("Ballpark geographic offset from ED50 to RGF93 v1", operation.name)
    assert(operation.ballpark_transformation?)
  end

  def test_allowed_intermediate_crs
    # There is no direct transformations between both
    source = Proj::Crs.create_from_database("EPSG", "4230", :PJ_CATEGORY_CRS)
    target = Proj::Crs.create_from_database("EPSG", "4171", :PJ_CATEGORY_CRS)

    # Restrict pivot to ETRS89
    factory_context = Proj::OperationFactoryContext.new("EPSG")
    factory_context.allowed_intermediate_crs = ["EPSG", "4258"]

    operations = factory_context.create_operations(source, target)
    assert_equal(1, operations.count)

    operation = operations[0]
    assert_equal("ED50 to ETRS89 (10) + Inverse of RGF93 v1 to ETRS89 (1)", operation.name)
  end

  def test_discard_superseded
    source = Proj::Crs.create_from_database("EPSG", "4203", :PJ_CATEGORY_CRS)
    target = Proj::Crs.create_from_database("EPSG", "4326", :PJ_CATEGORY_CRS)

    factory_context = Proj::OperationFactoryContext.new
    factory_context.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
    factory_context.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

    factory_context.discard_superseded = true
    operations = factory_context.create_operations(source, target)
    assert_equal(4, operations.count)

    factory_context.discard_superseded = false
    operations = factory_context.create_operations(source, target)
    assert_equal(5, operations.count)
  end
end
