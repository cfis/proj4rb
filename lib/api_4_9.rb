module Proj
  module Api
    #########  Deprecated API from proj_api.h. Don't use these anymore! ##############
    typedef :pointer, :projPJ

    class ProjUVW < FFI::Struct
      layout :u, :double,
             :v, :double,
             :w, :double
    end

    ProjXYZ = ProjUVW
    ProjLPZ = ProjUVW

    attach_function :pj_init, [:int, :pointer], :projPJ
    attach_function :pj_free, [:projPJ], :void
    attach_function :pj_get_errno_ref, [], :pointer
    attach_function :pj_strerrno, [:int], :string

    attach_function :pj_get_def, [:projPJ, :int], :string
    attach_function :pj_is_latlong, [:projPJ], :bool
    attach_function :pj_is_geocent, [:projPJ], :bool

    attach_function :pj_fwd3d, [ProjLPZ.by_value, :projPJ], ProjXYZ.by_value
    attach_function :pj_inv3d, [ProjXYZ.by_value, :projPJ], ProjLPZ.by_value
    attach_function :pj_transform, [:projPJ, :projPJ, :long, :int, :pointer, :pointer, :pointer], :bool

    if PROJ_VERSION < Gem::Version.new('5.0.0')
      def proj_torad(value)
        value * 0.017453292519943296
      end

      def proj_todeg(value)
        value * 57.295779513082321
      end
    end
  end
end