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
             :path_count, :ulong
    end

    attach_function :proj_info, :proj_info, [], PjInfo.by_value

    def self.proj_version
      info = proj_info
      info[:major] * 10000 + info[:minor] * 100 + info[:patch]
    end
  end
end
