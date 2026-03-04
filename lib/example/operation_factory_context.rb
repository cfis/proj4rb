# frozen_string_literal: true

require 'proj'

context = Proj::Context.new
source = Proj::Crs.create_from_database('EPSG', '4267', :PJ_CATEGORY_CRS)
target = Proj::Crs.create_from_database('EPSG', '4269', :PJ_CATEGORY_CRS)

factory = Proj::OperationFactoryContext.new(context)
factory.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
factory.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

operations = factory.create_operations(source, target)
raise 'no operations found' if operations.count.zero?

index = operations.suggested_operation(:PJ_FWD, Proj::Coordinate.new(x: 40, y: -100))
raise 'invalid suggested operation index' if index.negative? || index >= operations.count

puts "ok: best operation #{index} => #{operations[index].name}"
