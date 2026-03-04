# Coordinate Operations

Coordinate operations convert coordinates from one coordinate reference system to another. You need them whenever your data is in a different CRS than your target — for example, converting GPS coordinates (WGS 84) to a local projected grid for distance calculations.

PROJ divides coordinate operations into three groups:

- **Conversions** - coordinate operations that do not exert a change in reference frame. See the `Conversion` class and [proj.org/operations/conversions](https://proj.org/operations/conversions/index.html).
- **Projections** - cartographic mappings of the sphere onto the plane. Technically projections are conversions (according to ISO standards), but PROJ distinguishes them. See the `Projection` module and [proj.org/operations/projections](https://proj.org/operations/projections/index.html).
- **Transformations** - coordinate operations that do cause a change in reference frames. See the `Transformation` class.

For more information see [proj.org/operations](https://proj.org/operations/index.html).

## Transformations

After you have created two coordinate systems, you can create a transformation. For example, to convert coordinates from the "3-degree Gauss-Kruger zone 3" coordinate system to WGS84:

```ruby
crs_gk  = Proj::Crs.new('EPSG:31467')
crs_wgs84 = Proj::Crs.new('EPSG:4326')
transform = Proj::Transformation.new(crs_gk, crs_wgs84)
```

Alternatively, you can create a transformation without first creating Crs instances:

```ruby
transform = Proj::Transformation.new('EPSG:31467', 'EPSG:4326')
```

Once you've created the transformation, you can transform coordinates using the `forward` or `inverse` methods:

```ruby
from = Proj::Coordinate.new(x: 5428192.0, y: 3458305.0, z: -5.1790915237)
to = transform.forward(from)

assert_in_delta(48.98963932450735, to.x, 0.01)
assert_in_delta(8.429263044355544, to.y, 0.01)
assert_in_delta(-5.1790915237, to.z, 0.01)
assert_in_delta(0, to.t, 0.01)
```

The inverse transformation:

```ruby
from = Proj::Coordinate.new(lam: 48.9906726079, phi: 8.4302123334)
to = transform.inverse(from)

assert_in_delta(5428306.389495558, to.x, 0.01)
assert_in_delta(3458375.3367194114, to.y, 0.01)
assert_in_delta(0, to.z, 0.01)
assert_in_delta(0, to.t, 0.01)
```

## Coordinates

A `Coordinate` consists of up to four double values representing three directions plus time. In general you will need to fill out at least the first two values:

```ruby
from = Proj::Coordinate.new(x: 5428192.0, y: 3458305.0, z: -5.1790915237)
from = Proj::Coordinate.new(lam: 48.9906726079, phi: 8.4302123334)
```

`lam` is longitude and `phi` is latitude.

## Operation Factory

The `OperationFactoryContext` class can be used to build coordinate operations between two CRS objects. Create a factory, set appropriate filters (spatial, accuracy, grid availability, etc.), then query for a list of possible operations.

```ruby
source = Proj::Crs.create_from_database("EPSG", "4267", :PJ_CATEGORY_CRS)
target = Proj::Crs.create_from_database("EPSG", "4269", :PJ_CATEGORY_CRS)
context = Proj::Context.new

factory_context = Proj::OperationFactoryContext.new(context)
factory_context.spatial_criterion = :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION
factory_context.grid_availability = :PROJ_GRID_AVAILABILITY_IGNORED

operations = factory_context.create_operations(source, target)
```

See the [Examples](examples.md) page and `operation_factory_context_test.rb` for more details.

## Transforming Bounds

Use `transform_bounds` to transform a bounding box between coordinate reference systems. The method densifies the edges to account for nonlinear transformations:

```ruby
transform = Proj::Transformation.new('EPSG:4326', 'EPSG:3857')

bounds = Proj::Bounds.new(10.0, 50.0, 20.0, 60.0)
result = transform.transform_bounds(bounds, :PJ_FWD)

puts "xmin: #{result.xmin}, ymin: #{result.ymin}"
puts "xmax: #{result.xmax}, ymax: #{result.ymax}"
```

For 3D bounds transformations (PROJ 9.6+), use `transform_bounds_3d` with a `Bounds3d`:

```ruby
bounds = Proj::Bounds3d.new(10.0, 50.0, 0.0, 20.0, 60.0, 1000.0)
result = transform.transform_bounds_3d(bounds, :PJ_FWD)
```
