# Axis Order Normalization

Axis order is one of the most common sources of confusion when working with coordinate systems. Most people think of coordinates as longitude/latitude (x/y), but many official CRS definitions — including EPSG:4326 (WGS 84) — specify latitude/longitude order instead.

This became a major pain point when PROJ 6 changed how EPSG codes are handled (see [PROJ#1182](https://github.com/OSGeo/PROJ/pull/1182)). There were two breaking changes:

1. **Axis order** — PROJ now honours the official EPSG axis order. For most geographic CRS (like EPSG:4326), that means latitude/longitude, not longitude/latitude as older versions assumed.
2. **Units** — coordinates are expected in degrees for geodetic CRS, not radians.

If you pass coordinates in the wrong order, your results will be silently wrong — a point in San Francisco ends up somewhere in the Indian Ocean.

The fix is `normalize_for_visualization`, which forces the familiar longitude/latitude (x/y) order regardless of what the CRS definition says:

```ruby
# Build a transformation from geographic to Web Mercator.
transform = Proj::Transformation.new('EPSG:4326', 'EPSG:3857')

# Normalize axis handling so input/output follow common visualization order.
normalized = transform.normalize_for_visualization

# Longitude/latitude input for San Francisco.
coord = Proj::Coordinate.new(x: -122.4194, y: 37.7749)
result = normalized.forward(coord)

puts "Web Mercator: x=#{result.x}, y=#{result.y}"
```

See [lib/example/axis_order_normalization.rb](https://github.com/cfis/proj4rb/blob/master/lib/example/axis_order_normalization.rb)
