# Serialization Formats

CRS definitions need to be stored in files, exchanged between systems, and embedded in geospatial data formats. proj4rb can serialize any `PjObject` subclass to three standard formats: [WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_coordinate_reference_systems) (the OGC standard text format), [PROJJSON](https://proj.org/en/stable/specifications/projjson.html) (a JSON encoding), and classic PROJ strings.

```ruby
# Create a CRS object we can serialize into multiple text formats.
crs = Proj::Crs.new('EPSG:4326')

# WKT representation (single-line for compact output).
puts crs.to_wkt(:PJ_WKT2_2019, multiline: false)

# PROJJSON representation.
puts crs.to_json(multiline: false)

# Classic PROJ string representation.
puts crs.to_proj_string
```

See `lib/example/serialization_formats.rb`
