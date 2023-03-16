# encoding: UTF-8

module Proj
  # Represents a coordinate system for a {Crs CRS}
  class CoordinateSystem < PjObject
    # Create a CoordinateSystem
    #
    # @param context [Context] The context associated with the CoordinateSystem
    # @param cs_type [PJ_COORDINATE_SYSTEM_TYPE] Coordinate system type
    # @param axes [Array<PJ_AXIS_DESCRIPTION>] Array of Axes
    #
    # @return [CoordinateSystem]
    def self.create(cs_type, axes, context)
      axes_ptr = FFI::MemoryPointer.new(Api::PJ_AXIS_DESCRIPTION, axes.size)
      axes.each_with_index do |axis, i|
        axis_description_target = Api::PJ_AXIS_DESCRIPTION.new(axes_ptr[i])
        axis_description_source = axis.to_description
        axis_description_target.to_ptr.__copy_from__(axis_description_source.to_ptr, Api::PJ_AXIS_DESCRIPTION.size)
      end

      pointer = Api.proj_create_cs(context, cs_type, axes.count, axes_ptr)
      Error.check_context(context)
      self.create_object(pointer, context)
    end

    # Create an Ellipsoidal 2D CoordinateSystem
    #
    # @param context [Context] The context associated with the CoordinateSystem
    # @param cs_type [PJ_COORDINATE_SYSTEM_TYPE] Coordinate system type
    # @param unit_name [String] Name of the angular units. Or nil for degree
    # @param unit_conv_factor [Float] Conversion factor from the angular unit to radian. Set to 0 if unit name is degree
    #
    # @return [CoordinateSystem]
    def self.create_ellipsoidal_2d(cs_type, context, unit_name: nil, unit_conv_factor: 0)
      pointer = Api.proj_create_ellipsoidal_2D_cs(context, cs_type, unit_name, unit_conv_factor)
      Error.check_context(context)
      self.create_object(pointer, context)
    end

    # Create an Ellipsoidal 3D CoordinateSystem
    #
    # @param context [Context] The context associated with the CoordinateSystem
    # @param cs_type [PJ_COORDINATE_SYSTEM_TYPE] Coordinate system type
    # @param horizontal_angular_unit_name [String] Name of the angular units. Or nil for degree
    # @param horizontal_angular_unit_conv_factor [Float] Conversion factor from the angular unit to radian. Set to 0 if horizontal_angular_unit_name name is degree
    # @param vertical_linear_unit_name [String] Name of the linear units. Or nil for meters.
    #     # @param vertical_linear_unit_conv_factor [Float] Conversion factor from the linear unit to meter. Set to 0 if vertical_linear_unit_name is meter.
    #
    # @return [CoordinateSystem]
    def self.create_ellipsoidal_3d(cs_type, context, horizontal_angular_unit_name: nil, horizontal_angular_unit_conv_factor: 0, vertical_linear_unit_name: nil, vertical_linear_unit_conv_factor: 0)
      pointer = Api.proj_create_ellipsoidal_3D_cs(context, cs_type, horizontal_angular_unit_name, horizontal_angular_unit_conv_factor, vertical_linear_unit_name, vertical_linear_unit_conv_factor)
      Error.check_context(context)
      self.create_object(pointer, context)
    end

    # Create a CartesiansCS 2D coordinate system
    #
    # @param context [Context] The context associated with the CoordinateSystem
    # @param cs_type [PJ_COORDINATE_SYSTEM_TYPE] Coordinate system type
    # @param unit_name [String] Name of the unit. Default is nil.
    # @param unit_conv_factor [Float] Unit conversion factor to SI. Default is 0.
    #
    # @return [CoordinateSystem]
    def self.create_cartesian_2d(context, cs_type, unit_name: nil, unit_conv_factor: 0)
      pointer = Api.proj_create_cartesian_2D_cs(context, cs_type, unit_name, unit_conv_factor)
      Error.check_context(context)
      self.create_object(pointer, context)
    end

    # Returns the type of the coordinate system
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_cs_get_type
    #
    # @return [PJ_COORDINATE_SYSTEM_TYPE]
    def cs_type
      result = Api.proj_cs_get_type(self.context, self)
      if result == :PJ_CS_TYPE_UNKNOWN
        Error.check_object(self)
      end
      result
    end

    # Returns the number of axes in the coordinate system
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_cs_get_axis_count
    #
    # @return [Integer]
    def axis_count
      result = Api.proj_cs_get_axis_count(self.context, self)
      if result == -1
        Error.check_object(self)
      end
      result
    end

    # Returns information about a single axis
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_cs_get_axis_info
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
        Error.check_object(self)
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
