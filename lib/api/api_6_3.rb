module Proj
  module Api
    attach_function :proj_is_equivalent_to_with_ctx, [:PJ_CONTEXT, :PJ, :PJ, PJ_COMPARISON_CRITERION], :int
    attach_function :proj_coordoperation_create_inverse, [:PJ_CONTEXT, :PJ], :PJ
  end
end