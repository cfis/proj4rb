module Proj
  module Api
    attach_function :proj_rtodms2, [:pointer, :size_t, :double, :int, :int], :string
    attach_function :proj_get_area_of_use_ex, [:PJ_CONTEXT, :PJ, :int, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
  end
end