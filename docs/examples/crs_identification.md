# CRS Identification

You've received a shapefile, a GeoTIFF, or a WKT string from a colleague, and you need to figure out which standard CRS it corresponds to. `identify` matches an arbitrary CRS against well-known definitions in the PROJ database and returns a confidence score, so you can map it back to an EPSG code or other authority.

```ruby
crs = Proj::Crs.new('OGC:CRS84')
objects, confidences = crs.identify('OGC')

objects.count.times do |i|
  puts "#{objects[i]} (confidence: #{confidences[i]}%)"
end
```

A confidence of 100 means an exact match. Lower values indicate approximate matches. Pass `nil` as the authority to search all authorities.

See [lib/examples/crs_identification.rb](https://github.com/cfis/proj4rb/blob/master/lib/examples/crs_identification.rb)
