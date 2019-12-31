module Proj
  module Api
    attach_function :proj_log_level, [:PJ_CONTEXT, :PJ_LOG_LEVEL], :PJ_LOG_LEVEL
    callback :pj_log_function, [:pointer, :int, :string], :void
    attach_function :proj_log_func, [:PJ_CONTEXT, :pointer, :pj_log_function], :void
  end
end