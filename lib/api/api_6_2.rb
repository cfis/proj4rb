module Proj
  module Api
    attach_function :proj_create_crs_to_crs_from_pj, [:PJ_CONTEXT, :PJ, :PJ, :PJ_AREA, :string], :PJ
  end
end