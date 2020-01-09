module Proj
  module Api
    attach_function :proj_as_projjson, [:PJ_CONTEXT, :PJ, :pointer], :string
    attach_function :proj_create_crs_to_crs_from_pj, [:PJ_CONTEXT, :PJ, :PJ, :PJ_AREA, :string], :PJ
    attach_function :proj_context_set_autoclose_database, [:PJ_CONTEXT, :int], :void
  end
end