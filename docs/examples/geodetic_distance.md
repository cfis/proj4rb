# Geodesic Distance & Azimuth

A geodesic is the shortest path between two points along the Earth's surface. Unlike a straight-line distance calculated on a flat map, a geodesic follows the curvature of the ellipsoid and gives you the actual distance you'd travel. The difference matters — over long distances, flat-map calculations can be off by hundreds of kilometres.

## Distance

`lp_distance` computes the geodesic distance between two coordinates. Use this when you only need to know how far apart two points are. Coordinates must be in radians:

```ruby
crs = Proj::Crs.new('EPSG:4326')

paris  = Proj::Coordinate.new(x: Proj.degrees_to_radians(2.3522),
                               y: Proj.degrees_to_radians(48.8566))
berlin = Proj::Coordinate.new(x: Proj.degrees_to_radians(13.4050),
                               y: Proj.degrees_to_radians(52.5200))

distance = crs.lp_distance(paris, berlin)
puts "Distance: #{(distance / 1000).round(1)} km"
# => Distance: 879.7 km
```

## Distance with Azimuth

An azimuth is the compass bearing from one point to another, measured in degrees clockwise from north. Because the Earth is curved, the bearing from Paris to Berlin (forward azimuth) is different from the bearing at Berlin looking back to Paris (reverse azimuth).

`geod_distance` returns the same geodesic distance as `lp_distance`, but also includes both azimuths. Use this when you need to know which direction to travel, not just how far. The result is a `Coordinate` where `x` is distance (meters), `y` is forward azimuth (degrees), and `z` is reverse azimuth (degrees):

```ruby
result = crs.geod_distance(paris, berlin)

puts "Distance:        #{(result.x / 1000).round(1)} km"
puts "Forward azimuth: #{result.y.round(2)}°"
puts "Reverse azimuth: #{result.z.round(2)}°"
```

## Destination Point (PROJ 9.7+)

Given a starting point, a bearing, and a distance, where do you end up? `geod_direct` answers this:

```ruby
# From Paris, due north (azimuth 0), 100 km
endpoint = crs.geod_direct(paris, 0.0, 100_000)
puts "lon=#{Proj.radians_to_degrees(endpoint.x).round(4)}"
puts "lat=#{Proj.radians_to_degrees(endpoint.y).round(4)}"
```

Note: input coordinates must use longitude/latitude ordering in radians, regardless of the CRS axis order.

See `lib/examples/geodetic_distance.rb`
