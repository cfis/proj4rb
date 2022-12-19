require 'singleton'

module Proj
  class Config
    include Singleton

    def set_search_paths
      p_paths = self.search_paths_pointer
      items = p_paths.type_size/p_paths.size

      # Set search paths on default context - any new contexts will inherit from this
      if Api.method_defined?(:proj_context_set_search_paths)
        Api.proj_context_set_search_paths(nil, items, p_paths)
      end

      if Api.method_defined?(:pj_set_searchpath)
        Api.pj_set_searchpath(items, p_paths)
      end
    end

    def search_paths
      ['/usr/share/proj',
       '/usr/local/share/proj',
       '/opt/share/proj',
       '/opt/local/share/proj',
       'c:/msys64/mingw64/share/proj',
       'c:/mingw64/share/proj',
       '/opt/local/lib/proj6/share/proj',
       '/opt/local/lib/proj5/share/proj',
       '/opt/local/lib/proj49/share/proj']
    end

    def data_path
      if ENV['PROJ_LIB'] && File.directory?(ENV['PROJ_LIB'])
        ENV['PROJ_LIB']
      else
        result = self.search_paths.detect do |path|
          File.directory?(path)
        end

        unless result
          raise(Error, "Could not find Proj data directory. Please set the PROJ_LIB environmental variable to correct directory")
        end

        result
      end
    end

    def search_paths_pointer
      p_path = FFI::MemoryPointer.from_string(self.data_path)
      p_paths = FFI::MemoryPointer.new(:pointer, 1)
      p_paths[0].write_pointer(p_path)
      p_paths
    end

    def db_path
      result = self.search_paths.map do |path|
        File.join(path, 'proj.db')
      end.detect do |path|
        File.exist?(path)
      end

      unless result
        raise(Error, "Could not find Proj database (proj.db). Please set the PROJ_LIB environmental variable to directory that contains it")
      end

      result
    end
  end
end