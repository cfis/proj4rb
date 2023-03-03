module Proj
  # Proj 4.8 introduced the concept of a thread context object to support multi-threaded programs. The bindings
  # automatically create one context per thread (its stored in local thread storage).
  class Context
    attr_reader :database

    # Returns the default Proj context. This context *must* only be used in the main thread
    # In general it is better to create new contexts
    #
    # @return [Context] The default context
    def self.default
      result = Context.allocate
      # The default Proj Context is reprsented by a null pointer
      result.instance_variable_set(:@pointer, FFI::Pointer::NULL)
      result
    end

    # The context for the current thread. If a context does not exist
    # a new one is created
    #
    # @return [Context] The context for the current thread
    def self.current
      Thread.current[:proj_context] ||= Context.new
    end

    def self.finalize(pointer)
      proc do
        Api.proj_context_destroy(pointer)
      end
    end

    def initialize
      @pointer = Api.proj_context_create
      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))

      @database = Database.new(self)
    end

    def initialize_copy(original)
      ObjectSpace.undefine_finalizer(self)

      super

      @pointer = Api.proj_context_clone(original)
      @database = Database.new(self)

      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    def to_ptr
      @pointer
    end

    # Returns the current error-state of the context. An non-zero error codes indicates an error.
    #
    # See https://proj.org/development/reference/functions.html#c.proj_context_errno proj_context_errno
    #
    # return [Integer]
    def errno
      Api.proj_context_errno(self)
    end

    # Sets a custom log function
    #
    # @example
    #   context.set_log_function(data) do |pointer, int, message|
    #     ... do stuff...
    #   end
    #
    # @param pointer [FFI::MemoryPointer] Optional pointer to custom data
    # @param proc [Proc] Custom logging procedure
    # @return [nil]
    def set_log_function(pointer = nil, &proc)
      Api.proj_log_func(self, pointer, proc)
    end

    # Gets the current log level
    #
    # @return [PJ_LOG_LEVEL]
    def log_level
      Api.proj_log_level(self, :PJ_LOG_TELL)
    end

    # Sets the current log level
    #
    # @param value [PJ_LOG_LEVEL]
    # @return [nil]
    def log_level=(value)
      Api.proj_log_level(self, value)
    end

    # Gets if proj4 init rules are being used (i.e., support +init parameters)
    #
    # @return [Boolean]
    def use_proj4_init_rules
      result = Api.proj_context_get_use_proj4_init_rules(self, 0)
      result == 1 ? true : false
    end

    # Sets if proj4 init rules should be used
    #
    # @param value [Boolean]
    #
    # @return [nil]
    def use_proj4_init_rules=(value)
      Api.proj_context_use_proj4_init_rules(self, value ? 1 : 0)
    end

    # Sets the CA Bundle path which will be used by PROJ when curl and PROJ_NETWORK are enabled.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_ca_bundle_path proj_context_set_ca_bundle_path
    #
    # @param path [String] Path to CA bundle.
    #
    # @return [nil]
    def ca_bundle_path(path)
      path = path.encode!(:utf8)
      Api.proj_context_set_ca_bundle_path(self, path)
    end

    # Returns the cache used to store grid files locally
    #
    # @return [GridCache]
    def cache
      GridCache.new(self)
    end

    # Returns if network access is enabled allowing {Grid} files to be downloaded
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_is_network_enabled proj_context_is_network_enabled
    #
    # @return [Boolean] True if network access is enabled, otherwise false
    def network_enabled?
      result = Api.proj_context_is_network_enabled(self)
      result == 1 ? true : false
    end

    # Enable or disable network access for downloading grid files
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_enable_network proj_context_set_enable_network
    #
    # @param value [Boolean] Specifies if network access should be enabled or disabled
    def network_enabled=(value)
      Api.proj_context_set_enable_network(self, value ? 1 : 0)
    end

    # Returns the URL endpoint to query for remote grids
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_url_endpoint proj_context_get_url_endpoint
    #
    # @return [String] Endpoint URL
    def url
      Api.proj_context_get_url_endpoint(self)
    end

    # Sets the URL endpoint to query for remote grids. This overrides the default endpoint in the PROJ configuration file or with the PROJ_NETWORK_ENDPOINT environment variable.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_url_endpoint proj_context_set_url_endpoint
    #
    # @param value [String] Endpoint URL
    def url=(value)
      Api.proj_context_set_url_endpoint(self, value)
    end

    # Returns the user directory used to save grid files.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_user_writable_directory proj_context_get_user_writable_directory
    #
    # @param [Boolean] If set to TRUE, create the directory if it does not exist already. Defaults to false
    #
    # @return [String] Directory
    def user_directory(create = false)
      Api.proj_context_get_user_writable_directory(self, create ? 1 : 0)
    end

    # Sets the paths that Proj will search when opening one of its resource files
    # such as the proj.db database, grids, etc.
    #
    # If set on the default context, they will be inherited by contexts created later.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_search_paths proj_context_set_search_paths
    def search_paths=(paths)
      # Convert paths to C chars
      paths_ptr = paths.map do |path|
        FFI::MemoryPointer.from_string(path)
      end

      pointer = FFI::MemoryPointer.new(:pointer, paths.size)
      pointer.write_array_of_pointer(paths_ptr)

      if Api.method_defined?(:proj_context_set_search_paths)
        Api.proj_context_set_search_paths(self, paths.size, pointer)
      elsif Api.method_defined?(:pj_set_searchpath)
        Api.pj_set_searchpath(paths.size, pointer)
      end
    end

    # ---  Deprecated -------
    def database_path
      self.database.path
    end

    # Sets the path to the Proj database
    def database_path=(value)
      self.database.path = value
    end

    extend Gem::Deprecate
    deprecate :database_path, "context.database.path", 2023, 6
    deprecate :database_path=, "context.database.path=", 2023, 6
  end
end