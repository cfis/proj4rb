# proj4rb

Ruby bindings for the [Proj](https://proj.org) coordinate transformation library. The Proj library supports converting coordinates between a number of different coordinate systems and projections.

## Installation

Next install the Proj library. This varies per system, but you want to install the latest version possible. Once installed, you'll need to make sure that libproj is on your operating system's load path.

Then install the gem:

```console
gem install proj4rb
```

## Quick Start

```ruby
require 'proj'

# Create a transformation between two coordinate systems
transform = Proj::Transformation.new('EPSG:31467', 'EPSG:4326')

# Transform a coordinate
from = Proj::Coordinate.new(x: 5428192.0, y: 3458305.0, z: -5.1790915237)
to = transform.forward(from)

puts "lat: #{to.x}, lon: #{to.y}"
```

## Documentation

Full documentation is available at https://cfis.github.io/proj4rb/ including:

- [Getting Started](https://cfis.github.io/proj4rb/)
- [CRS](https://cfis.github.io/proj4rb/crs/)
- [Coordinate Operations](https://cfis.github.io/proj4rb/coordinate_operations/)
- [How-To Guides](https://cfis.github.io/proj4rb/examples/)
- [API Reference](https://cfis.github.io/proj4rb/reference/)

## Environment Variables

See [Configuration](https://cfis.github.io/proj4rb/configuration/) for details.

- `PROJ_LIB_PATH` - Override the path to the `libproj` shared library.
- `PROJ_DATA` - Path to the folder containing `proj.db` (Proj 6+). Must be set before Ruby launches.

## License

proj4rb is released under the MIT license.

## Authors

The proj4rb Ruby bindings were started by Guilhem Vellut with most of the code written by Jochen Topf. Charlie Savage ported the code to Windows, added the Windows build infrastructure, rewrote the code to use FFI and then ruby-bindgen, and updated it to support Proj version 5 through 9.
