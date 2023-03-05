module Proj
  module Api
    attach_function :proj_rtodms2, [:pointer, :size_t, :double, :int, :int], :string
  end
end