# proj4rb

Ruby bindings for the [Proj](https://proj.org) coordinate transformation library. The Proj library supports converting coordinates between a number of different coordinate systems and projections.

## Installation

First install the gem:

```console
gem install proj4rb
```

Next install the Proj library. This varies per system, but you want to install the latest version possible. Once installed, you'll need to make sure that libproj is on your operating system's load path.

!!! warning "Apple Silicon (ARM64)"

    There is a [known bug](https://github.com/ffi/ffi/pull/1178) in ruby-ffi on Apple Silicon (M-series) Macs that causes incorrect results from coordinate transformations. The issue is an ABI mismatch where libffi uses integer registers instead of floating-point registers for unions of doubles. Symptoms include coordinate values returned as near-zero garbage (e.g. `2.48e-314`). This will be resolved once the fix is merged into ruby-ffi.

## Getting Started

Load the library:

```ruby
require 'proj'
```

If you are migrating from the old Proj4 namespace, `require 'proj4'` still works.

### Create a CRS

A coordinate reference system (CRS) defines how coordinates map to locations on the Earth. Create one from an EPSG code:

```ruby
crs = Proj::Crs.new('EPSG:4326')
puts crs.name       #=> "WGS 84"
puts crs.proj_type  #=> :PJ_TYPE_GEOGRAPHIC_2D_CRS
```

### Transform Coordinates

To convert coordinates between two CRS, create a `Transformation`:

```ruby
transform = Proj::Transformation.new('EPSG:31467', 'EPSG:4326')

from = Proj::Coordinate.new(x: 5428192.0, y: 3458305.0, z: -5.1790915237)
to = transform.forward(from)

puts "lat: #{to.x}, lon: #{to.y}"
```

Use `forward` to go from source to target CRS, and `inverse` for the reverse direction:

```ruby
back = transform.inverse(to)
```

### Calculate Distance

Compute the geodesic distance between two points on the ellipsoid:

```ruby
crs = Proj::Crs.new('EPSG:4326')

paris  = Proj::Coordinate.new(x: Proj.degrees_to_radians(2.3522),
                               y: Proj.degrees_to_radians(48.8566))
berlin = Proj::Coordinate.new(x: Proj.degrees_to_radians(13.4050),
                               y: Proj.degrees_to_radians(52.5200))

distance = crs.lp_distance(paris, berlin)
puts "#{(distance / 1000).round(1)} km"  #=> "879.7 km"
```

### Query the Database

The PROJ database contains thousands of CRS definitions:

```ruby
database = Proj::Database.new(Proj::Context.current)
crs_infos = database.crs_info('EPSG')
puts "#{crs_infos.count} EPSG entries"
```

### Next Steps

See the [How-To Guides](examples.md) for more task-oriented examples, or the [API Reference](reference/) for full documentation.

For changes by version, see the [Changelog](https://github.com/cfis/proj4rb/blob/master/CHANGELOG.md). Some APIs are version-gated; see [Configuration](configuration.md#version-gated-apis).

## License

proj4rb is released under the MIT license.

## Authors

The proj4rb Ruby bindings were started by Guilhem Vellut with most of the code written by Jochen Topf. Charlie Savage ported the code to Windows, added the Windows build infrastructure, rewrote the code to use FFI and then ruby-bindgen, and updated it to support Proj version 5 through 9.
