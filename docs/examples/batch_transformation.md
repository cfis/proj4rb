# Batch Transformation

When you have many coordinates to transform — a GPS track, a set of survey points, a grid of values — calling `forward` in a loop works but is slow because each call crosses the Ruby-to-C boundary. `transform_array` sends the entire array to PROJ in a single call, which is significantly faster for large datasets.

```ruby
conversion = Proj::Conversion.new('+proj=utm +zone=32 +ellps=GRS80')

coordinates = [
  Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(55), z: 45),
  Proj::Coordinate.new(lon: Proj.degrees_to_radians(12), lat: Proj.degrees_to_radians(56), z: 50),
  Proj::Coordinate.new(lon: Proj.degrees_to_radians(13), lat: Proj.degrees_to_radians(55), z: 30)
]

results = conversion.transform_array(coordinates, :PJ_FWD)

results.each_with_index do |coord, i|
  puts "Point #{i}: x=#{coord.x.round(2)}, y=#{coord.y.round(2)}, z=#{coord.z}"
end
```

Individual points that fail to transform will have their components set to `Infinity` rather than raising an exception immediately.

See `lib/examples/batch_transformation.rb`
