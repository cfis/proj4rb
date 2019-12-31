require 'singleton'

module Proj
  class Config
    include Singleton

    def proj_lib
      ENV['PROJ_LIB'] || find_path
    end

    def search_paths
      ['/usr/share/proj',
       '/usr/local/share/proj',
       '/opt/share/proj',
       '/opt/local/share/proj',
       'c:/msys64/mingw64/share/proj',
       'c:/mingw64/share/proj',
       '/opt/local/lib/proj49/share/proj',
       '/opt/local/lib/proj5/share/proj',
       '/opt/local/lib/proj6/share/proj']
    end

    def data_path
      result = self.search_paths.detect do |path|
        File.directory?(path)
      end

      unless result
        raise(Error, "Could not find Proj data directory. Please set the PROJ_LIB environmental variable to correct directory")
      end

      result
    end

    def db_path
      result = self.search_paths.map do |path|
        File.join(path, 'proj.db')
      end.detect do |path|
        File.exists?(path)
      end

      unless result
        raise(Error, "Could not find Proj database (proj.db). Please set the PROJ_LIB environmental variable to directory that contains it")
      end

      result
    end
  end
end