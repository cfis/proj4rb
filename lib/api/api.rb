require 'rbconfig'
require 'ffi'

module Proj
  module Api
    extend FFI::Library

    def self.library_versions
      ["25", # 9.2
       "9_1", # 9.1
       "22", # 8.0 and 8.1
       "19", # 7.x
       "17", # 6.1 *and* 6.2
       "15", # 6.0
       "14", # 5.2
       "13", # 5.0
       "12", # 4.9
       "11"] # 4.9
    end

    def self.search_paths
      result = case RbConfig::CONFIG['host_os']
                 when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
                   self.windows_search_paths
                 when /darwin|mac os/
                   self.macos_search_paths
                 else
                   self.linux_search_paths
               end

       # Try libproj as catch all
      result << 'libproj'
      result
    end

    def self.windows_search_paths
      self.library_versions.map do |version|
        ["libproj-#{version}", "libproj_#{version}"]
      end.flatten
    end

    def self.linux_search_paths
      self.library_versions.map do |version|
        "libproj.so.#{version}"
      end
    end

    def self.macos_search_paths
      # On MacOS only support HomeBrew since the MacPort is unsupported and ancient (5.2).
      self.library_versions.map do |version|
        "libproj.#{version}.dylib"
      end
    end

    def self.load_library
      if ENV["PROJ_LIB_PATH"]
        ffi_lib ENV["PROJ_LIB_PATH"]
      else
        ffi_lib self.search_paths
      end

      ffi_libraries.first
    end

    def self.load_api
      # First load the base 5.0 api so we can determine the Proj Version
      require_relative './api_5_0'
      Api.const_set('PROJ_VERSION', Gem::Version.new(self.proj_info[:version]))

      # Now load the rest of the apis based on the proj version
      versions = ['5.1.0', '5.2.0',
                  '6.0.0', '6.1.0', '6.2.0', '6.3.0',
                  '7.0.0', '7.1.0', '7.2.0',
                  '8.0.0', '8.1.0', '8.2.0',
                  '9.1.0', '9.2.0']

      versions.each do |version|
        api_version = Gem::Version.new(version)

        if PROJ_VERSION >= api_version
          require_relative "./api_#{api_version.segments[0]}_#{api_version.segments[1]}"
        end
      end

      # Add in the experimental api
      require_relative "./api_experimental"
    end

    # Load the library
    load_library

    # Load the api
    load_api
  end
end

