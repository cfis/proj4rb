module Proj
  module Api
    class PROJ_UNIT_INFO < FFI::Struct
      layout :auth_name, :string,
             :code, :string,
             :name, :string,
             :category, :string,
             :conv_factor, :double,
             :proj_short_name, :string,
             :deprecated, :int
    end

    attach_function :proj_get_units_from_database, [:PJ_CONTEXT, :string, :string, :int, :pointer], :pointer #PROJ_UNIT_INFO
    attach_function :proj_unit_list_destroy, [:pointer], :void
  end
end