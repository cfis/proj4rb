module Proj
  # Proj 4.8 introduced the concept of a thread context object to support multi-threaded programs. The bindings
  # automatically create one context per thread (its stored in local thread storage).
  class Context
    attr_reader :database

    # The context for the current thread
    #
    # @return [Context]
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

    # Get the last error number
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

    # Returns if network access is enabled
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_is_network_enabled proj_context_is_network_enabled
    #
    # @return [Boolean] True if network access is enabled, otherwise false
    def network_enabled?
      result = Api.proj_context_is_network_enabled(self)
      result == 1 ? true : false
    end

    # Enable or disable network access
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
    def url_endpoint
      Api.proj_context_get_url_endpoint(self)
    end

    # Sets the URL endpoint to query for remote grids. This overrides the default endpoint in the PROJ configuration file or with the PROJ_NETWORK_ENDPOINT environment variable.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_url_endpoint proj_context_set_url_endpoint
    #
    # @param value [String] Endpoint URL
    def url_endpoint=(value)
      Api.proj_context_set_url_endpoint(self, value)
    end

    # Returns the PROJ user writable directory for datumgrid files.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_user_writable_directory proj_context_get_user_writable_directory
    #
    # @param [Boolean] If set to TRUE, create the directory if it does not exist already. Defaults to false
    #
    # @return [String] Directory
    def user_writable_directory(create = false)
      Api.proj_context_get_user_writable_directory(self, create ? 1 : 0)
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