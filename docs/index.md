# proj4rb

Ruby bindings for the [Proj](https://proj.org) coordinate transformation library. The Proj library supports converting coordinates between a number of different coordinate systems and projections.

## Documentation

Reference documentation is available at [rubydoc.info/github/cfis/proj4rb](https://rubydoc.info/github/cfis/proj4rb).

Examples can be found in the [Examples](examples.md) page. In addition, the test suite has examples of calling almost every API so when in doubt take a look at them.

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

The `PjObject` class defines several methods to create new objects:

- `PjObject.create`
- `PjObject.create_from_database`
- `PjObject.create_from_name`
- `PjObject.create_from_wkt`

These methods return instances of the correct subclass.

## License

proj4rb is released under the MIT license.

## Authors

The proj4rb Ruby bindings were started by Guilhem Vellut with most of the code written by Jochen Topf. Charlie Savage ported the code to Windows, added the Windows build infrastructure, rewrote the code to support Proj version 5 and 6, and ported it to use FFI.
