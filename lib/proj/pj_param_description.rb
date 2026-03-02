module Proj
  module Api
    class PjParamDescription
      def self.create(name:, auth_name: nil, code: nil, value:, unit_name: nil, unit_conv_factor:, unit_type:)
        result = PjParamDescription.new
        # String fields are const char* (:string) so we write pointers directly to the underlying memory
        result.pointer.put_pointer(result.offset_of(:name), FFI::MemoryPointer.from_string(name))
        result.pointer.put_pointer(result.offset_of(:auth_name), auth_name ? FFI::MemoryPointer.from_string(auth_name) : FFI::Pointer::NULL)
        result.pointer.put_pointer(result.offset_of(:code), code ? FFI::MemoryPointer.from_string(code) : FFI::Pointer::NULL)
        result[:value] = value
        result.pointer.put_pointer(result.offset_of(:unit_name), unit_name ? FFI::MemoryPointer.from_string(unit_name) : FFI::Pointer::NULL)
        result[:unit_conv_factor] = unit_conv_factor
        result[:unit_type] = unit_type
        result
      end
    end
  end
end
