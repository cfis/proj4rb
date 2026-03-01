# Contexts

Contexts support multi-threaded programs. The bindings expose this via `Context.current`, stored in thread-local storage. Use the context to access error codes, set proj4 compatibility settings, set logging level, and install custom logging code.

Both `Crs` and `Transformation` objects accept a context in their constructors. If none is passed, they default to `Context.current`.

```ruby
context = Proj::Context.new
crs = Proj::Crs.new("EPSG:4326", context)
```

## Network Access

Proj supports downloading grid files on demand if network access is enabled (disabled by default). To enable, use `Context#network_enabled=`. To specify the url endpoint, use `Context#url=`. Advanced users can replace Proj's networking code (which uses libcurl) with their own implementation via the `NetworkApi` class.

## Grid Cache

Downloaded grids are cached in a sqlite file named `cache.db`. To configure the cache location, size, and other characteristics, use the `GridCache` class accessible via `Context#cache`. The default cache size is 300MB. Caching is on by default but can be disabled via `GridCache#enabled=`.

## Error Handling

When an error occurs, a `Proj::Error` instance is raised with the underlying message from the Proj library.
