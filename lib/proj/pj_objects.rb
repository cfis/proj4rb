# encoding: UTF-8
module Proj
  class PjObjects
    def self.finalize(pointer)
      proc do
        Api.proj_list_destroy(pointer)
      end
    end

    def initialize(pointer, context)
      @pointer = pointer
      @context = context
      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    def to_ptr
      @pointer
    end

    def context
      @context || Context.current
    end

    def count
      Api.proj_list_get_count(self)
    end
    alias :size :count

    def [](index)
      ptr = Api.proj_list_get(context, self, index)
      PjObject.create_object(ptr, self.context)
    end

    # Returns the index of the operation that would be the most appropriate to transform the specified coordinates.
    #
    # @param direction [PJ_DIRECTION] - Direction into which to transform the point.
    # @param coord [Coordinate] - Coordinate to transform
    #
    # @return [Integer] - Index of operation
    def suggested_operation(direction, coord)
      Api.proj_get_suggested_operation(self.context, self, direction, coord)
    end
  end
end
