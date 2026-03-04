# Serialization

All proj4rb objects that inherit from `PjObject` can be serialized to multiple formats: WKT, PROJJSON, and Proj strings.

## WKT (Well-Known Text)

WKT is the standard text representation for coordinate reference systems and operations:

```ruby
crs = Proj::Crs.new('EPSG:4326')

# WKT2:2019 (default)
puts crs.to_wkt

# WKT2:2015
puts crs.to_wkt(:PJ_WKT2_2015)

# WKT1 (GDAL style)
puts crs.to_wkt(:PJ_WKT1_GDAL)

# WKT1 (ESRI style)
puts crs.to_wkt(:PJ_WKT1_ESRI)

# Single line, custom indentation
puts crs.to_wkt(:PJ_WKT2_2019, multiline: false)
puts crs.to_wkt(:PJ_WKT2_2019, indentation_width: 2)
```

### Creating from WKT

```ruby
wkt = 'GEOGCRS["WGS 84", ...]'
crs = Proj::PjObject.create_from_wkt(wkt)
```

You can also guess the WKT dialect:

```ruby
dialect = Proj::Context.current.wkt_dialect(wkt)
```

## PROJJSON

PROJJSON is a JSON encoding of WKT2:

```ruby
crs = Proj::Crs.new('EPSG:4326')

puts crs.to_json
puts crs.to_json(multiline: false)
puts crs.to_json(indentation_width: 4)
```

## Proj Strings

The classic Proj string format (e.g., `+proj=longlat +datum=WGS84`):

```ruby
crs = Proj::Crs.new('EPSG:4326')
puts crs.to_proj_string
# +proj=longlat +datum=WGS84 +no_defs +type=crs
```

Options:

```ruby
puts crs.to_proj_string(:PJ_PROJ_5, multiline: true)
puts crs.to_proj_string(:PJ_PROJ_5, use_approx_tmerc: true)
```

## Object Inspection

All PjObject instances expose metadata:

```ruby
crs = Proj::Crs.new('EPSG:4326')

puts crs.name          # "WGS 84"
puts crs.auth_name     # "EPSG"
puts crs.id_code       # "4326"
puts crs.auth          # "EPSG:4326"
puts crs.proj_type     # :PJ_TYPE_GEOGRAPHIC_2D_CRS
puts crs.remarks
puts crs.scope
puts crs.deprecated?   # false

area = crs.area_of_use
puts area.name
puts "#{area.west_lon_degree}, #{area.south_lat_degree}"
puts "#{area.east_lon_degree}, #{area.north_lat_degree}"
```
