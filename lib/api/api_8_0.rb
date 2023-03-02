module Proj
  module Api
    attach_function :proj_crs_is_derived, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_context_errno_string, [:PJ_CONTEXT, :int], :string
  end
end