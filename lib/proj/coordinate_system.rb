# encoding: UTF-8

module Proj
  # @!attribute [r] name
  #   @return [String] Axis name
  # @!attribute [r] abbreviation
  #   @return [String] Axis abbreviation
  # @!attribute [r] direction
  #   @return [String] Axis direction
  # @!attribute [r] unit_conv_factor
  #   @return [String] Axis unit_conv_factor
  # @!attribute [r] unit_name
  #   @return [String] Axis unit_name
  # @!attribute [r] unit_auth_name
  #   @return [String] Axis unit_auth_name
  # @!attribute [r] unit_code
  #   @return [String] Axis unit_code
  AxisInfo = Struct.new(:name, :abbreviation, :direction,
                        :unit_conv_factor, :unit_name, :unit_auth_name, :unit_code,
                        keyword_init: true)

  # Represents a coordinate system for a {Crs CRS}
  class CoordinateSystem
    # @!visibility private
    def self.finalize(pointer)
      proc do
        Api.proj_destroy(pointer)
      end
    end

    # Creates a new coordinate system
    def initialize(pointer, context=nil)
      @pointer = pointer
      @context = context
      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    # @!visibility private
    def to_ptr
      @pointer
    end

    def context
      @context
    end

    # Returns the type of the coordinate system
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_cs_get_type proj_cs_get_type
    #
    # @return [PJ_COORDINATE_SYSTEM_TYPE]
    def type
      result = Api.proj_cs_get_type(self.context, self)
      if result == :PJ_CS_TYPE_UNKNOWN
        Error.check
      end
      result
    end

    # Returns the number of axes in the coordinate system
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_cs_get_axis_count proj_cs_get_axis_count
    #
    # @return [Integer]
    def axis_count
      result = Api.proj_cs_get_axis_count(self.context, self)
      if result == -1
        Error.check
      end
      result
    end

    # Returns information about a single axis
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_cs_get_axis_info proj_cs_get_axis_info
    #
    # @param index [Integer] Index of the axis
    #
    # @return [AxisInfo]
    def axis_info(index)
      p_name = FFI::MemoryPointer.new(:pointer)
      p_abbreviation = FFI::MemoryPointer.new(:pointer)
      p_direction = FFI::MemoryPointer.new(:pointer)
      p_unit_conv_factor = FFI::MemoryPointer.new(:double)
      p_unit_name = FFI::MemoryPointer.new(:pointer)
      p_unit_auth_name = FFI::MemoryPointer.new(:pointer)
      p_unit_code = FFI::MemoryPointer.new(:pointer)

      result = Api.proj_cs_get_axis_info(self.context, self, index,
                                         p_name, p_abbreviation, p_direction, p_unit_conv_factor, p_unit_name, p_unit_auth_name, p_unit_code)

      unless result
        Error.check
      end

      AxisInfo.new(name: p_name.read_pointer.read_string,
                   abbreviation: p_abbreviation.read_pointer.read_string_to_null,
                   direction: p_direction.read_pointer.read_string_to_null,
                   unit_conv_factor: p_unit_conv_factor.read_double,
                   unit_name: p_unit_name.read_pointer.read_string_to_null,
                   unit_auth_name: p_unit_auth_name.read_pointer.read_string_to_null,
                   unit_code: p_unit_code.read_pointer.read_string_to_null)
    end

    # Returns information about all axes
    #
    # @return [Array<AxisInfo>]
    def axes
      self.axis_count.times.map do |index|
        self.axis_info(index)
      end
    end
  end
end
