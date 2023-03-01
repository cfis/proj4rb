module Proj
  module Api
    attach_function :proj_trans_bounds, [:PJ_CONTEXT, :PJ, PJ_DIRECTION, :double, :double, :double, :double,
                                         :pointer, :pointer, :pointer, :pointer, :int], :int
  end
end