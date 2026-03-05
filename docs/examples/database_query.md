# Database Querying

The PROJ database contains thousands of coordinate reference systems. Use the `Database` class to enumerate and filter them.

## List Authorities and Codes

```ruby
database = Proj::Database.new(Proj::Context.current)

authorities = database.authorities
puts authorities.to_a.join(', ')

codes = database.codes('EPSG', :PJ_TYPE_GEOGRAPHIC_2D_CRS)
puts "EPSG geographic 2D CRS count: #{codes.count}"
```

## Query CRS Info

`crs_info` returns detailed metadata including name, type, area of use, and geographic bounds:

```ruby
crs_infos = database.crs_info('EPSG')

info = crs_infos.first
puts "#{info.auth_name}:#{info.code} - #{info.name}"
puts "Type: #{info.crs_type}"
puts "Area: #{info.area_name}"
puts "Bounds: W=#{info.west_lon_degree}, S=#{info.south_lat_degree}, E=#{info.east_lon_degree}, N=#{info.north_lat_degree}"
```

You can also pass a `Parameters` object to filter by geographic area, CRS type, or other criteria. See the `Parameters` class in the [API Reference](../reference/) for available filters.

See [lib/examples/database_query.rb](https://github.com/cfis/proj4rb/blob/master/lib/examples/database_query.rb)
