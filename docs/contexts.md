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

Note that `Error.check_context` does not reset the error state (errno) on the context. If you are performing operations that may fail and you want to continue afterwards, use a fresh `Context.new` for each such operation rather than reusing `Context.current`. This avoids stale error state from a previous failure affecting later error checks.

```ruby
# Use a fresh context for operations that may fail
context = Proj::Context.new
begin
  crs = Proj::Crs.new("EPSG:9999999", context)
rescue Proj::Error
  # The error is on this context only; Context.current is unaffected
end
```
