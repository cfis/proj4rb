require 'ffi'

module Proj
  module Api
    extend FFI::Library
    ffi_lib ['libproj-15', # Mingw64 Proj 6
             'libproj.so.15', # Linux (Postgresql repository )Proj 6
             'libproj.so.13', # Linux (Fedora 31) Proj 5
             'libproj.so.12', # Linux (Ubuntu 18.04 ) Proj 4
             'libproj-12', # Mingw64 Proj 4
             '/opt/local/lib/proj6/lib/libproj.dylib', # Macports Proj 6
             '/opt/local/lib/proj5/lib/libproj.dylib', # Macports Proj 5
             'libproj'] # Generic catch all (not used anywhere?)

    library = ffi_libraries.first

    # proj_info was introduced in Proj 5
    if library.find_function('proj_info')
      class PJ_INFO < FFI::Struct
        layout :major, :int, # Major release number
               :minor, :int,  # Minor release number
               :patch, :int,  # Patch level
               :release, :string,  # Release info. Version + date
               :version, :string,   # Full version number
               :searchpath, :string,  # Paths where init and grid files are looked for. Paths are separated by
               # semi-colons on Windows, and colons on non-Windows platforms.
               :paths, :pointer,
               :path_count, :size_t
      end

      attach_function :proj_info, [], PJ_INFO.by_value
      PROJ_VERSION = Gem::Version.new(self.proj_info[:version])
    else
      PROJ_VERSION = Gem::Version.new('4.9.0')
    end
  end

  # Load the old deprecated api - supported by all Proj versions (until Proj 7!)
  require_relative './api_4_9'

  if Api::PROJ_VERSION >= Gem::Version.new('5.0.0')
    require_relative './api_5_0'
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