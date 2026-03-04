# proj4rb

Ruby bindings for the [Proj](https://proj.org) coordinate transformation library. The Proj library supports converting coordinates between a number of different coordinate systems and projections.

## Documentation

Reference documentation is available at [API Reference](reference/).

Guides:

- [Configuration](configuration.md)
- [Contexts](contexts.md)
- [Coordinate Operations](coordinate_operations.md)
- [Coordinate Reference Systems](crs.md)
- [Database](database.md)
- [Examples](examples.md)
- [Geodetic Objects](geodetic_objects.md)
- [Grids](grids.md)
- [Serialization](serialization.md)
- [ruby-bindgen / FFI bindings](ruby_bindgen.md)

In addition, the test suite has examples of calling almost every API so when in doubt take a look at them.

## Installation

First install the gem:

```console
gem install proj4rb
```

Next install the Proj library. This varies per system, but you want to install the latest version possible. Once installed, you'll need to make sure that libproj is on your operating system's load path.

## Quick Start

```ruby
require 'proj'

# Create a transformation
transform = Proj::Transformation.new('EPSG:31467', 'EPSG:4326')

# Transform a coordinate
from = Proj::Coordinate.new(x: 5428192.0, y: 3458305.0, z: -5.1790915237)
to = transform.forward(from)

puts "lat: #{to.x}, lon: #{to.y}"
```

If you are using the old Proj4 namespace:

```ruby
require 'proj4'
```

## Class Hierarchy

The proj4rb class hierarchy is based on Proj's class hierarchy, which is derived from the [OGC Abstract Specification](http://docs.opengeospatial.org/as/18-005r5/18-005r5.html):

```
PjObject
  CoordinateOperationMixin
    Conversion
    Transformation
  CoordinateSystem
  Crs
  Datum
  Ellipsoid
  PrimeMeridian
```

Additional supporting classes:

```
Area
Bounds
Bounds3d
Coordinate
Context
Database
GridCache
Operation
OperationFactoryContext
Parameter
Session
Unit
```

The `PjObject` class defines several methods to create new objects:

- `PjObject.create`
- `PjObject.create_from_database`
- `PjObject.create_from_name`
- `PjObject.create_from_wkt`

These methods return instances of the correct subclass.

## What Is New By PROJ Version

- **PROJ 9.4**
  - `Crs#point_motion_operation?` uses `proj_crs_has_point_motion_operation`.
  - Added `Projection.lambert_conic_conformal_1sp_variant_b`.
- **PROJ 9.5**
  - Added `Context#set_user_writable_directory`.
  - Added `CoordinateOperationMixin#requires_per_coordinate_input_time?`.
  - Added `Projection.local_orthographic`.
- **PROJ 9.6**
  - Added `Bounds3d`.
  - Added `CoordinateOperationMixin#transform_bounds_3d`.
- **PROJ 9.7**
  - Added `PjObject#geod_direct`.

Some APIs are version-gated. See [Configuration](configuration.md#version-gated-apis).

## License

proj4rb is released under the MIT license.

## Authors

The proj4rb Ruby bindings were started by Guilhem Vellut with most of the code written by Jochen Topf. Charlie Savage ported the code to Windows, added the Windows build infrastructure, rewrote the code to support Proj version 5 and 6, and ported it to use FFI.
