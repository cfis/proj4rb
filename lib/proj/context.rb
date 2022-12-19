module Proj
  # Proj 4.8 introduced the concept of a thread context object to support multi-threaded programs. The bindings
  # automatically create one context per thread (its stored in local thread storage).
  class Context
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

      set_database_path
    end

    # Helper method that tries to locate the Proj coordinate database (proj.db)
    def set_database_path
      return unless Api.method_defined?(:proj_context_get_database_path)
      return if database_path

      self.database_path = Config.instance.db_path
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

    # Gets the path the Proj database
    #
    # return [String]
    def database_path
      Api.proj_context_get_database_path(self)
    end

    # Sets the path to the Proj database
    def database_path=(value)
      result = Api.proj_context_set_database_path(self, value, nil, nil)
      unless result == 1
        Error.check(self.errno)
      end
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
    # @return [:PJ_LOG_LEVEL]
    def log_level
      Api.proj_log_level(self, :PJ_LOG_TELL)
    end

    # Sets the current log level
    #
    # @param value [:PJ_LOG_LEVEL]
    # @return [nil]
    def log_level=(value)
      Api.proj_log_level(self, value)
    end

    # Gets if proj4 init rules are being used (i.e., support +init parameters)
    #
    # @return [Boolean]
    def use_proj4_init_rules
      Api.proj_context_get_use_proj4_init_rules(self, 0)
    end

    # Sets if proj4 init rules should be used
    #
    # @param value [Boolean]
    # @return [nil]
    def use_proj4_init_rules=(value)
      Api.proj_context_use_proj4_init_rules(self, value ? 1 : 0)
    end
  end
end