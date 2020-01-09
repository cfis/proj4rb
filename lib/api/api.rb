require 'ffi'

module Proj
  module Api
    extend FFI::Library

    proj_library_versions = {'proj6' => 15,
                             'proj5' => 13,
                             'proj49' => 12}

    file_patterns = ["libproj-%d", # Mingw64
                     "libproj.so.%d", # Linux
                     "/opt/local/lib/%s/lib/libproj.%d.dylib", # Macports
                     "/usr/local/lib/libproj.%d.dylib"] # Mac HomeBrew

    search_paths = file_patterns.map do |file_pattern|
                     proj_library_versions.map do |proj_version, proj_library_version|
                       formats = file_pattern.count("%") == 1 ? [proj_library_version] : [proj_version, proj_library_version]
                       file_pattern % formats
                     end
                   end.flatten

    ffi_lib search_paths

    # Load the old deprecated api - supported by all Proj versions (until Proj 7!)
    require_relative './api_4_9'

    library = ffi_libraries.first

    # proj_info was introduced in Proj 5
    if library.find_function('proj_info')
      require_relative './api_5_0'
      PROJ_VERSION = Gem::Version.new(self.proj_info[:version])
    else
      release = self.pj_get_release
      version = release.match(/\d\.\d\.\d/)
      PROJ_VERSION = Gem::Version.new(version)
    end
  end

  if Api::PROJ_VERSION < Gem::Version.new('5.0.0')
    def Api.proj_torad(value)
      value * 0.017453292519943296
    end

    def Api.proj_todeg(value)
      value * 57.295779513082321
    end
  end

  if Api::PROJ_VERSION >= Gem::Version.new('5.1.0')
    require_relative './api_5_1'
  end

  if Api::PROJ_VERSION >= Gem::Version.new('5.2.0')
    require_relative './api_5_2'
  end

  if Api::PROJ_VERSION >= Gem::Version.new('6.0.0')
    require_relative './api_6_0'
  end

  if Api::PROJ_VERSION >= Gem::Version.new('6.1.0')
    require_relative './api_6_1'
  end

  if Api::PROJ_VERSION >= Gem::Version.new('6.2.0')
    require_relative './api_6_2'
  end
end