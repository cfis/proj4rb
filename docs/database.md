# Database

Starting with version 6, Proj stores its reference data (datums, ellipsoids, prime meridians, coordinate systems, units, etc.) in a SQLite file called `proj.db`. The `Database` class provides access to this data.

Every `Context` has an associated database accessible via `Context#database`.

## Querying

### Authorities

List the authorities available in the database:

```ruby
context = Proj::Context.new
authorities = context.database.authorities
# ["EPSG", "IGNF", "NKG", "OGC", "PROJ", ...]
```

### CRS Information

Enumerate CRS entries, optionally filtered by authority:

```ruby
crs_list = context.database.crs_info("EPSG")
crs_list.each do |info|
  puts "#{info.auth_name}:#{info.code} - #{info.name} (#{info.type})"
end
```

### Authority Codes

Get all codes for a given object type under an authority:

```ruby
codes = context.database.codes("EPSG", :PJ_TYPE_GEOGRAPHIC_2D_CRS)
```

### Units

List available units, optionally filtered by authority or category:

```ruby
# All units
units = context.database.units

# Linear units only
linear_units = context.database.units(category: "linear")

# Get a specific unit
metre = context.database.unit("EPSG", "9001")
puts "#{metre.name}: #{metre.conv_factor}"
```

### Metadata

Query database metadata:

```ruby
version = context.database.metadata("EPSG.VERSION")
date = context.database.metadata("EPSG.DATE")
```

### Grids

Look up grid information:

```ruby
grid = context.database.grid("us_noaa_alaska.tif")
```

### Celestial Bodies

List celestial bodies known to the database:

```ruby
bodies = context.database.celestial_bodies
```

## Database Path

By default, Proj finds `proj.db` automatically. You can override the path:

```ruby
context.database.path = "/custom/path/to/proj.db"
```

Or set the `PROJ_DATA` environment variable before launching Ruby (see [Configuration](configuration.md)).
