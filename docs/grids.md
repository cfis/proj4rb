# Grids

Proj uses grid files for high-accuracy coordinate transformations (datum shifts). Grid files contain offset data that is applied during transformations. The `Grid` class manages downloading and querying grid files.

## Checking Grid Availability

Grids referenced by transformations can be checked for availability:

```ruby
grid = context.database.grid("us_noaa_alaska.tif")
puts grid.available?     # Whether grid is available at runtime
puts grid.downloadable?  # Whether grid can be downloaded
puts grid.open_license?  # Whether grid has an open license
```

## Downloading Grids

Proj can download grid files on demand. Network access must be enabled on the context first (see [Contexts](contexts.md)).

```ruby
context = Proj::Context.new
context.network_enabled = true

grid = context.database.grid("us_noaa_alaska.tif")

unless grid.downloaded?
  grid.download do |progress|
    puts "Download progress: #{(progress * 100).round}%"
  end
end
```

## Grid Information

For grids available through the legacy API:

```ruby
info = Proj.grid_info("us_noaa_alaska.tif")
```

## Grid Cache

Downloaded grids are cached locally in a SQLite file. Configure the cache through `Context#cache`:

```ruby
context = Proj::Context.new
cache = context.cache

cache.enabled = true
cache.path = "/custom/cache/path/cache.db"
cache.max_size = 500  # MB
cache.ttl = 86400     # seconds
cache.clear           # clear the cache
```

The default cache size is 300MB. See [Contexts](contexts.md) for more details.
