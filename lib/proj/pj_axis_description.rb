module Proj
  module Api
    class PjAxisDescription
      attr_accessor :retained_ptrs

      def self.create(name:, abbreviation:, direction:, unit_name:, unit_conv_factor:, unit_type:)
        result = PjAxisDescription.new
        result.retained_ptrs = []
        result.put_string(:name, name)
        result.put_string(:abbreviation, abbreviation)
        result.put_string(:direction, direction)
        result.put_string(:unit_name, unit_name)
        result[:unit_conv_factor] = unit_conv_factor
        result[:unit_type] = unit_type
        result
      end

      # Write a string into a :string field and retain the pointer to prevent GC.
      def put_string(field, value)
        ptr = FFI::MemoryPointer.from_string(value)
        @retained_ptrs << ptr
        pointer.put_pointer(offset_of(field), ptr)
      end
    end
  end
end
