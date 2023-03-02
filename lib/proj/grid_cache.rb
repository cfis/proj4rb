module Proj
  # To avoid repeated network access, it is possible to enable a local cache of grids.
  # Grid data is stored in a SQLite3 database, cache.db, that is by default stored
  # stored in the PROJ user writable directory.
  #
  # The local cache is enabled by default with a size of 300MB. Cache settings can be overridden
  # by this class, env variables or the proj.ini file
  #
  # @see https://proj.org/usage/network.html#caching
  class GridCache
    attr_reader :context

    def initialize(context)
      @context = context
    end

    # Enables or disables the grid cache
    #
    # @param value [Boolean]
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_grid_cache_set_enable proj_grid_cache_set_enable
    def enabled=(value)
      Api.proj_grid_cache_set_enable(self.context, value ? 1 : 0)
    end

    # Set the path and file of the local cache file which is sqlite database. By default
    # it is stored in the user writable directory.
    #
    # @param value [String] - Full path to the cache. If set to nil then caching will be disabled.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_grid_cache_set_filename proj_grid_cache_set_filename
    def path=(value)
      Api.proj_grid_cache_set_filename(self.context, value.encode('UTF-8'))
      value
    end

    # Sets the cache size
    #
    # @param value [Integer] Maximum size in Megabytes (1024*1024 bytes), or negative value to set unlimited size.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_grid_cache_set_max_size proj_grid_cache_set_max_size
    def max_size=(value)
      Api.proj_grid_cache_set_max_size(self.context, value)
      value
    end

    # Specifies the time-to-live delay for re-checking if the cached properties of files are still up-to-date.
    #
    # @param value [Integer] Delay in seconds. Use negative value for no expiration.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_grid_cache_set_ttl proj_grid_cache_set_ttl
    def ttl=(value)
      Api.proj_grid_cache_set_ttl(self.context, value)
      value
    end

    # Clears the cache
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_grid_cache_clear proj_grid_cache_clear
    def clear
      Api.proj_grid_cache_clear(self.context)
    end
  end
end
