module Proj
  module Api
    #########  Deprecated API from proj_api.h. Don't use these anymore! ##############
    typedef :pointer, :projPJ

    class ProjUV < FFI::Struct
      layout :u, :double,
             :v, :double
    end

    ProjXY = ProjUV
    ProjLP = ProjUV

    attach_function :pj_init, [:int, :pointer], :projPJ
    attach_function :pj_free, [:projPJ], :void

    attach_function :pj_get_release, [], :string
    attach_function :pj_set_searchpath, [:int, :pointer], :void

    attach_function :pj_get_errno_ref, [], :pointer
    attach_function :pj_strerrno, [:int], :string

    attach_function :pj_get_def, [:projPJ, :int], :string
    attach_function :pj_is_latlong, [:projPJ], :bool
    attach_function :pj_is_geocent, [:projPJ], :bool

    attach_function :pj_fwd, [ProjLP.by_value, :projPJ], ProjXY.by_value
    attach_function :pj_inv, [ProjXY.by_value, :projPJ], ProjLP.by_value
    attach_function :pj_transform, [:projPJ, :projPJ, :long, :int, :pointer, :pointer, :pointer], :bool
  end
end