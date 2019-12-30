module Proj
  class Context
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

      figure_database_path
    end

    def figure_database_path
      return unless Api.method_defined?(:proj_context_get_database_path)
      return if database_path

      # No database path is set. Unfortunately ffi does not provide an api to tell us the location of the proj library.
      # So just guess on paths
      paths = ['/usr/share/proj', '/usr/local/share/proj', '/opt/share/proj', '/opt/local/share/proj',
               'c:/msys64/mingw64/share/proj', 'c:/mingw64/share/proj'].map do |path|
                File.join(path, 'proj.db')
      end

      path = paths.detect do |path|
              File.exists?(path)
             end

      if path
        self.database_path = path
      else
        raise(Error, "Could not find proj.db. Please set the PROJ_LIB environmental variable to the directory that contains proj.db.")
      end
    end

    def to_ptr
      @pointer
    end

    def errno
      Api.proj_context_errno(self)
    end

    def database_path
      Api.proj_context_get_database_path(self)
    end

    def database_path=(value)
      result = Api.proj_context_set_database_path(self, value, nil, nil)
      unless result == 1
        Error.check(self.errno)
      end
    end

    def set_log_function(pointer = nil, &proc)
      Api.proj_log_func(self, pointer, proc)
    end

    def log_level
      Api.proj_log_level(self, :PJ_LOG_TELL)
    end

    def log_level=(value)
      Api.proj_log_level(self, value)
    end

    def use_proj4_init_rules
      Api.proj_context_get_use_proj4_init_rules(self, 0)
    end

    def use_proj4_init_rules=(value)
      Api.proj_context_use_proj4_init_rules(self, value ? 1 : 0)
    end
  end
end