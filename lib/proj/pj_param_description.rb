module Proj
  module Api
    class PjParamDescription
      attr_accessor :retained_ptrs

      def self.create(name:, auth_name: nil, code: nil, value:, unit_name: nil, unit_conv_factor:, unit_type:)
        result = PjParamDescription.new
        result.retained_ptrs = []
        result.put_string(:name, name)
        result.put_string(:auth_name, auth_name)
        result.put_string(:code, code)
        result[:value] = value
        result.put_string(:unit_name, unit_name)
        result[:unit_conv_factor] = unit_conv_factor
        result[:unit_type] = unit_type
        result
      end

      # Write a string into a :string field and retain the pointer to prevent GC.
      def put_string(field, value)
        return if value.nil?
        ptr = FFI::MemoryPointer.from_string(value)
        @retained_ptrs << ptr
        pointer.put_pointer(offset_of(field), ptr)
      end
    end
  end
end
