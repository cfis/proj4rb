module Proj
  class Ellipsoid < PjObject
    # Returns a list of ellipsoids that are built into Proj. A more comprehensive
    # list is stored in the Proj database and can be queried via PjObject#create_from_database
    def self.built_in
      pointer_to_array = FFI::Pointer.new(Api::PJ_ELLPS, Api.proj_list_ellps)

      result = Array.new
      0.step do |i|
        pj_ellps = Api::PJ_ELLPS.new(pointer_to_array[i])
        break result if pj_ellps[:id].nil?
        result << pj_ellps
      end
      result
    end

    # Returns ellipsoid parameters
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_ellipsoid_get_parameters
    #
    # @return [Hash] Hash of ellipsoid parameters. Axes are in meters
    def parameters
      @parameters ||= begin
        out_semi_major_metre = FFI::MemoryPointer.new(:double)
        out_semi_minor_metre = FFI::MemoryPointer.new(:double)
        out_is_semi_minor_computed = FFI::MemoryPointer.new(:int)
        out_inv_flattening = FFI::MemoryPointer.new(:double)

        result = Api.proj_ellipsoid_get_parameters(self.context, self, out_semi_major_metre, out_semi_minor_metre, out_is_semi_minor_computed, out_inv_flattening)

        if result != 1
          Error.check_object(self)
        end

        {semi_major_axis: out_semi_major_metre.read_double,
         semi_minor_axis: out_semi_minor_metre.read_double,
         semi_minor_axis_computed: out_is_semi_minor_computed.read_int == 1 ? true : false,
         inverse_flattening: out_inv_flattening.null? ? nil : out_inv_flattening.read_double}
      end
    end

    # Returns the semi-major axis in meters
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_ellipsoid_get_parameters
    #
    # @return [Double]
    def semi_major_axis
      self.parameters[:semi_major_axis]
    end

    # Returns the semi-minor axis in meters
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_ellipsoid_get_parameters
    #
    # @return [Double]
    def semi_minor_axis
      self.parameters[:semi_minor_axis]
    end

    # Returns whether the semi-minor axis is computed
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_ellipsoid_get_parameters
    #
    # @return [Boolean]
    def semi_minor_axis_computed
      self.parameters[:semi_minor_axis_computed]
    end

    # Returns the inverse flattening value
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_ellipsoid_get_parameters
    #
    # @return [Double]
    def inverse_flattening
      self.parameters[:inverse_flattening]
    end
  end
end