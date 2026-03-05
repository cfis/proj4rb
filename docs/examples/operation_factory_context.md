# Operation Factory Context

There is often more than one way to transform between two CRS — different operations with different accuracies, grid requirements, and areas of validity. `OperationFactoryContext` lets you query all available operations and pick the best one for a specific coordinate or region, rather than relying on PROJ's default choice.

```ruby
context = Proj::Context.new
source = Proj::Crs.create_from_database('EPSG', '4267', :PJ_CATEGORY_CRS)
target = Proj::Crs.create_from_database('EPSG', '4269', :PJ_CATEGORY_CRS)

factory = Proj::OperationFactoryContext.new(context)
factory.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
factory.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

operations = factory.create_operations(source, target)
index = operations.suggested_operation(:PJ_FWD, Proj::Coordinate.new(x: 40, y: -100))

puts "Best operation index: #{index}"
puts "Operation name: #{operations[index].name}"
```

See [lib/examples/operation_factory_context.rb](https://github.com/cfis/proj4rb/blob/master/lib/examples/operation_factory_context.rb)
