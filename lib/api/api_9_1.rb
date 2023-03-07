module Proj
  module Api
    attach_function :proj_trans_get_last_used_operation, [:PJ], :PJ
    attach_function :proj_operation_factory_context_set_area_of_interest_name, [:PJ_CONTEXT, :pointer, :string], :void
    attach_function :proj_area_set_name, [:PJ_AREA, :string], :void
  end
end