# Geodetic to Projected Coordinates

The most common coordinate transformation: converting longitude/latitude (geodetic coordinates) to x/y values on a flat map (projected coordinates). This example transforms a point in Copenhagen from WGS 84 geographic coordinates to UTM zone 32 easting/northing, and back again.

```ruby
require 'proj'

context = Proj::Context.new
crs_projected = Proj::Crs.new('+proj=utm +zone=32 +datum=WGS84 +type=crs', context)
crs_geodetic = crs_projected.geodetic_crs

transform = Proj::Transformation.new(crs_geodetic, crs_projected, context)

from = Proj::Coordinate.new(lon: 12.0, lat: 55.0)
to = transform.forward(from)

puts "Projected: x=#{to.x}, y=#{to.y}"

back = transform.inverse(to)
puts "Back to geodetic: lon=#{back.lon}, lat=#{back.lat}"
```

See [lib/examples/geodetic_to_projected.rb](https://github.com/cfis/proj4rb/blob/master/lib/examples/geodetic_to_projected.rb)
