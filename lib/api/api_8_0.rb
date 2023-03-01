module Proj
  module Api
    attach_function :proj_crs_is_derived, [:PJ_CONTEXT, :PJ], :int
  end
end