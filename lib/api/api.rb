require 'ffi'

module Proj
  module Api
    extend FFI::Library
    ffi_lib ['libproj-15', # Mingw64 Proj 6
             'libproj.so.15', # Linux (Postgresql repository )Proj 6
             'libproj.so.13', # Linux (Fedora 31) Proj 5
             'libproj.so.12', # Linux (Ubuntu 18.04 ) Proj 4
             'libproj-12', # Mingw64 Proj 4
             '/opt/local/lib/proj6/lib/libproj.15.dylib', # Macports Proj 6
             '/opt/local/lib/proj5/lib/libproj.13.dylib', # Macports Proj 5
             '/opt/local/lib/proj49/lib/libproj.12.dylib', # Macports Proj 5
             '/usr/local/lib/libproj.15.dylib', # mac homebrew mac Proj 6
             '/usr/local/lib/libproj.13.dylib', # mac howbrew Proj 5
             '/usr/local/lib/libproj.12.dylib' # mac howbrew Proj 5
            ] 

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