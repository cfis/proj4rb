# Transformation With Area Of Interest

When transforming between two CRS, PROJ may have several candidate operations to choose from — each optimised for a different geographic region. By specifying an area of interest, you tell PROJ which region your data covers so it can select the most accurate operation for that area rather than guessing.

```ruby
area = Proj::Area.new(
  west_lon_degree: -114.1324,
  south_lat_degree: 49.5614,
  east_lon_degree: 3.76488,
  north_lat_degree: 62.1463
)

transform = Proj::Transformation.new('EPSG:4277', 'EPSG:4326', area: area)
from = Proj::Coordinate.new(x: 50, y: -2)
to = transform.forward(from)

puts "Transformed: x=#{to.x}, y=#{to.y}"
```

See `lib/example/transformation_with_area.rb`
