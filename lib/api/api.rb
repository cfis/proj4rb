require 'rbconfig'
require 'ffi'

module Proj
  module Api
    extend FFI::Library

    def self.library_versions
      ["9_1", # 9.1
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
      # Mac Ports
      paths1 = self.library_versions.map do |version|
        case version
          when 15..17
            "/opt/local/lib/proj6/lib/libproj.#{version}.dylib"
          when 13..14
            "/opt/local/lib/proj5/lib/libproj.#{version}.dylib"
          when 11..12
            "/opt/local/lib/proj49/lib/libproj.#{version}.dylib"
        end
      end

      # Mac HomeBrew
      paths2 = self.library_versions.map do |version|
        "/usr/local/lib/libproj.#{version}.dylib"
      end

      paths1 + paths2
    end

    if ENV["PROJ_LIB_PATH"]
      ffi_lib ENV["PROJ_LIB_PATH"]
    else
      ffi_lib self.search_paths
    end

    library = ffi_libraries.first

    # proj_info was introduced in Proj 5
    if library.find_function('proj_info')
      require_relative './api_5_0'
      PROJ_VERSION = Gem::Version.new(self.proj_info[:version])
    else
      # Load the old deprecated api
      require_relative './api_4_9'

      release = self.pj_get_release
      version = release.match(/\d\.\d\.\d/)
      PROJ_VERSION = Gem::Version.new(version)
    end
  end

  # Load the old deprecated API for versions before version 8
  if Api::PROJ_VERSION < Gem::Version.new('8.0.0')
    require_relative './api_4_9'
  end

  versions = ['5.1.0', '5.2.0',
              '6.0.0', '6.1.0', '6.2.0', '6.3.0',
              '7.0.0', '7.1.0', '7.2.0',
              '8.0.0', '8.1.0', '8.2.0',
              '9.1.0', '9.2.0']
  versions.each do |version|
    api_version = Gem::Version.new(version)

    if Api::PROJ_VERSION >= api_version
      require_relative "./api_#{api_version.segments[0]}_#{api_version.segments[1]}"
    end
  end
end