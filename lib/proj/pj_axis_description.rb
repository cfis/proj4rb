module Proj
  module Api
    class PjAxisDescription
      def self.create(name:, abbreviation:, direction:, unit_name:, unit_conv_factor:, unit_type:)
        result = PjAxisDescription.new
        result[:name] = FFI::MemoryPointer.from_string(name)
        result[:abbreviation] = FFI::MemoryPointer.from_string(abbreviation)
        result[:direction] = FFI::MemoryPointer.from_string(direction)
        result[:unit_name] = FFI::MemoryPointer.from_string(unit_name)
        result[:unit_conv_factor] = unit_conv_factor
        result[:unit_type] = unit_type
        result
      end
    end
  end
end
