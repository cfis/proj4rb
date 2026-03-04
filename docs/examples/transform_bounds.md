# Transforming Bounds

Transform a bounding box between coordinate reference systems. You can't just transform the four corners — coordinate transformations can curve the edges, so the true extent may lie between the corners. `transform_bounds` handles this by adding intermediate sample points along each edge before transforming, then taking the outermost values.

```ruby
transform = Proj::Transformation.new('EPSG:4326',
  '+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs')

bounds = Proj::Bounds.new(40, -120, 64, -80)
result = transform.transform_bounds(bounds, :PJ_FWD, 21)

puts "xmin=#{result.xmin.round(2)}, ymin=#{result.ymin.round(2)}"
puts "xmax=#{result.xmax.round(2)}, ymax=#{result.ymax.round(2)}"
```

The `densify_points` parameter (default 21) controls how many sample points are added along each edge. Higher values give more accurate bounds at the cost of performance.

For 3D bounds (PROJ 9.6+), use `transform_bounds_3d` with a `Bounds3d`:

```ruby
bounds = Proj::Bounds3d.new(10.0, 50.0, 0.0, 20.0, 60.0, 1000.0)
result = transform.transform_bounds_3d(bounds, :PJ_FWD)
```

See `lib/examples/transform_bounds.rb`
