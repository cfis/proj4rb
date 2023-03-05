module Proj
  module Api
    attach_function :proj_cleanup, [], :void
    attach_function :proj_as_projjson, [:PJ_CONTEXT, :PJ, :pointer], :string
    attach_function :proj_create_crs_to_crs_from_pj, [:PJ_CONTEXT, :PJ, :PJ, :PJ_AREA, :pointer], :PJ
    attach_function :proj_grid_get_info_from_database, [:PJ_CONTEXT, :string, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
    attach_function :proj_context_set_autoclose_database, [:PJ_CONTEXT, :int], :void
    attach_function :proj_operation_factory_context_set_discard_superseded, [:PJ_CONTEXT, :pointer, :int], :void
  end
end