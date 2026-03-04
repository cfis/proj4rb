module Proj
  module Api
    class PjInfo < FFI::Struct
      layout :major, :int,
             :minor, :int,
             :patch, :int,
             :release, :string,
             :version, :string,
             :searchpath, :string,
             :paths, :pointer,
             :path_count, :size_t
    end

    attach_function :proj_info, :proj_info, [], PjInfo.by_value

    def self.proj_version
      info = proj_info
      info[:major] * 10000 + info[:minor] * 100 + info[:patch]
    end

    info = proj_info
    Proj::Api::PROJ_VERSION = Gem::Version.new("#{info[:major]}.#{info[:minor]}.#{info[:patch]}")
  end
end
