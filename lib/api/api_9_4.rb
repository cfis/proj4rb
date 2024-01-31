module Proj
  module Api
    attach_function :proj_coordinate_metadata_create, [:PJ_CONTEXT, :PJ, :double], :PJ
    attach_function :proj_crs_has_point_motion_operation, [:PJ_CONTEXT, :PJ], :int
  end
end