module Proj
  module Api
    attach_function :proj_normalize_for_visualization, [:PJ_CONTEXT, :PJ], :PJ
  end
end