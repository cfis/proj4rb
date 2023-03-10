module Proj
  class PrimeMeridian < PjObject
    # Returns a list of Prime Meridians that are built into Proj. A more comprehensive
    # list is stored in the Proj database and can be queried via PjObject#create_from_database
    def self.built_in
      pointer_to_array = FFI::Pointer.new(Api::PJ_PRIME_MERIDIANS, Api.proj_list_prime_meridians)
      result = Array.new
      0.step do |i|
        prime_meridian_info = Api::PJ_PRIME_MERIDIANS.new(pointer_to_array[i])
        break result if prime_meridian_info[:id].nil?
        result << prime_meridian_info
      end
      result
    end

    # Returns prime meridian parameters
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_prime_meridian_get_parameters
    #
    # @return [Hash] Hash of ellipsoid parameters. Axes are in meters
    def parameters
      @parameters ||= begin
                        out_longitude = FFI::MemoryPointer.new(:double)
                        out_unit_conv_factor = FFI::MemoryPointer.new(:double)
                        out_unit_name = FFI::MemoryPointer.new(:string)

                        result = Api.proj_prime_meridian_get_parameters(self.context, self, out_longitude, out_unit_conv_factor, out_unit_name)

                        if result != 1
                          Error.check_object(self)
                        end

                        {longitude: out_longitude.read_double,
                         unit_conv_factor: out_unit_conv_factor.read_double,
                         unit_name: out_unit_name.read_pointer.read_string_to_null}
                      end
    end

    # Returns the longitude of the prime meridian in its native unit
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_prime_meridian_get_parameters
    #
    # @return [Double]
    def longitude
      self.parameters[:longitude]
    end

    # Returns the conversion factor of the prime meridian longitude unit to radians
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_prime_meridian_get_parameters
    #
    # @return [Double]
    def unit_conv_factor
      self.parameters[:unit_conv_factor]
    end

    # Returns the unit name
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_prime_meridian_get_parameters
    #
    # @return [String ]
    def unit_name
      self.parameters[:unit_name]
    end
  end
end