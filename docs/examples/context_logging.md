# Context Logging

When a transformation gives unexpected results or fails silently, PROJ's internal log messages can tell you what went wrong — a missing grid file, an invalid CRS, a fallback operation being used. By default these messages are hidden. Install a custom log function to capture them.

```ruby
context = Proj::Context.new

context.set_log_function do |_pointer, level, message|
  puts "[level=#{level}] #{message}"
end
```

Log levels:

- `:PJ_LOG_NONE` (0) — no logging
- `:PJ_LOG_ERROR` (1) — errors only (default)
- `:PJ_LOG_DEBUG` (2) — errors and debug messages
- `:PJ_LOG_TRACE` (3) — all messages including trace

To increase verbosity:

```ruby
context.log_level = :PJ_LOG_DEBUG
```

See [lib/examples/context_logging.rb](https://github.com/cfis/proj4rb/blob/master/lib/examples/context_logging.rb)
