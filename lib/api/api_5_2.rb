module Proj
  module Api
    attach_function :proj_errno_string, [:int], :string
  end
end