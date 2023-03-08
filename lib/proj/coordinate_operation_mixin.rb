# encoding: UTF-8
require 'stringio'

module Proj
  Param = Struct.new(:name, :auth_name, :code, :value, :value_string,
                     :unit_conv_factor, :unit_name, :unit_auth_name, :unit_code, :unit_category,
                     keyword_init: true)

  # Coordinate Operations convert {Coordinate coordintates} to a new value. In Proj they are
  # can either by {Conversion conversions} that do not exert a change in reference frame
  # or {Transformation transformations} which do.
  module CoordinateOperationMixin
    # Return whether a coordinate operation can be instantiated as a PROJ pipeline, checking in particular that referenced grids are available.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_is_instantiable proj_coordoperation_is_instantiable
    #
    # @return [Boolean]
    def instantiable?
      result = Api.proj_coordoperation_is_instantiable(self.context, self)
      result == 1 ? true : false
    end

    # Returns a coordinate operation that represents the inverse operation of this operation
    #
    # @return [Conversion, Transformation] Returns nil on error
    def create_inverse
      ptr = Api.proj_coordoperation_create_inverse(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # @!visibility private
    def method_info
      out_method_name = FFI::MemoryPointer.new(:string)
      out_method_auth_name = FFI::MemoryPointer.new(:string)
      out_method_code = FFI::MemoryPointer.new(:string)

      result = Api.proj_coordoperation_get_method_info(self.context, self, out_method_name, out_method_auth_name, out_method_code)

      if result != 1
        Error.check(self.context)
      end

      {:method_name => out_method_name.read_pointer.read_string_to_null,
       :method_auth_name => out_method_auth_name.read_pointer.read_string_to_null,
       :method_code => out_method_code.read_pointer.read_string_to_null}
    end

    # Returns the operation name
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_method_info proj_coordoperation_get_method_info
    #
    # @return [String]
    def method_name
      method_info[:method_name]
    end

    # Returns the operation authority name
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_method_info proj_coordoperation_get_method_info
    #
    # @return [String]
    def method_auth_name
      method_info[:method_auth_name]
    end

    # Returns the operation code
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_method_info proj_coordoperation_get_method_info
    #
    # @return [String]
    def method_code
      method_info[:method_code]
    end

    # Returns the number of parameters of a SingleOperation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_param_count proj_coordoperation_get_param_count
    #
    # @return [Integer]
    def param_count
      Api.proj_coordoperation_get_param_count(self.context, self)
    end

    # Returns the index of a parameter of a SingleOperation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_param_index proj_coordoperation_get_param_index
    #
    # @param name [String] Name of the parameter. Must not be nil
    #
    # @return [Integer] Index of the parameter or -1 in case of error.
    def param_index(name)
      Api.proj_coordoperation_get_param_index(self.context, self, name)
    end

    # Returns a parameter of a SingleOperation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_param proj_coordoperation_get_param
    #
    # @param index [Integer] Parameter index
    #
    # @return [Param]
    def param(index)
      out_name = FFI::MemoryPointer.new(:string)
      out_auth_name = FFI::MemoryPointer.new(:string)
      out_code = FFI::MemoryPointer.new(:string)
      out_value = FFI::MemoryPointer.new(:double)
      out_value_string = FFI::MemoryPointer.new(:string)
      out_unit_conv_factor = FFI::MemoryPointer.new(:double)
      out_unit_name = FFI::MemoryPointer.new(:string)
      out_unit_auth_name = FFI::MemoryPointer.new(:string)
      out_unit_code = FFI::MemoryPointer.new(:string)
      out_unit_category = FFI::MemoryPointer.new(:string)

      result = Api.proj_coordoperation_get_param(self.context, self, index,
                                                 out_name, out_auth_name, out_code,
                                                 out_value, out_value_string,
                                                 out_unit_conv_factor,
                                                 out_unit_name, out_unit_auth_name,out_unit_code,
                                                 out_unit_category)
      if result != 1
        Error.check(self.context)
      end

      name_ptr = out_name.read_pointer
      auth_name_ptr = out_auth_name.read_pointer
      code_ptr = out_code.read_pointer
      value_string_ptr = out_value_string.read_pointer
      unit_name_ptr = out_unit_name.read_pointer
      unit_auth_name_ptr = out_unit_auth_name.read_pointer
      unit_code_ptr = out_unit_code.read_pointer
      unit_category_ptr = out_unit_category.read_pointer

      Param.new(name: name_ptr.null? ? nil : name_ptr.read_string_to_null,
                auth_name: auth_name_ptr.null? ? nil : auth_name_ptr.read_string_to_null,
                code: code_ptr.null? ? nil : code_ptr.read_string_to_null,
                value: out_value.null? ? nil : out_value.read_double,
                value_string: value_string_ptr.null? ? nil : value_string_ptr.read_string_to_null,
                unit_conv_factor: out_unit_conv_factor.null? ? nil : out_unit_conv_factor.read_double,
                unit_name: unit_name_ptr.null? ? nil : unit_name_ptr.read_string_to_null,
                unit_auth_name: unit_auth_name_ptr.null? ? nil : unit_auth_name_ptr.read_string_to_null,
                unit_code: unit_code_ptr.null? ? nil : unit_code_ptr.read_string_to_null,
                unit_category: unit_category_ptr.null? ? nil : unit_category_ptr.read_string_to_null)
    end

    # Transforms a {Coordinate} from the source {Crs} to the target {Crs}. Coordinates should be expressed in
    # the units and axis order of the definition of the source CRS. The returned transformed coordinate will
    # be in the units and axis order of the definition of the target CRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_trans proj_trans
    #
    # @param coord [Coordinate]
    #
    # @return [Coordinate]
    def forward(coord)
      self.transform(coord, :PJ_FWD)
    end

    # Transforms a {Coordinate} from the target {Crs} to the source {Crs}. Coordinates should be expressed in
    # the units and axis order of the definition of the source CRS. The returned transformed coordinate will
    # be in the units and axis order of the definition of the target CRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_trans proj_trans
    #
    # @param coord [Coordinate]
    #
    # @return [Coordinate]
    def inverse(coord)
      self.transform(coord, :PJ_INV)
    end

    # Transforms a {Coordinate} in the specified direction. See {CoordinateOperation#forward forward} and
    # {CoordinateOperation#inverse inverse}
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_trans proj_trans
    #
    # @param direction [PJ_DIRECTION] Direction of transformation (:PJ_FWD or :PJ_INV)
    # @param coord [Coordinate]
    #
    # @return [Coordinate]
    def transform(coord, direction)
      struct = Api.proj_trans(self, direction, coord)
      Coordinate.from_coord(struct)
    end

    # Transform boundary densifying the edges to account for nonlinear transformations along these edges
    # and extracting the outermost bounds.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_trans_bounds
    #
    # @param bounds [Area] Bounding box in source CRS (target CRS if direction is inverse).
    # @param direction [PJ_DIRECTION] The direction of the transformation.
    # @param densify_points [Integer] Recommended to use 21. This is the number of points to use to densify the bounding polygon in the transformation.
    #
    # @return [Area] Bounding box in target CRS (target CRS if direction is inverse).
    def transform_bounds(bounds, direction, densify_points = 21)
      out_xmin = FFI::MemoryPointer.new(:double)
      out_ymin = FFI::MemoryPointer.new(:double)
      out_xmax = FFI::MemoryPointer.new(:double)
      out_ymax = FFI::MemoryPointer.new(:double)

      result = Api.proj_trans_bounds(self.context, self, direction,
                                     bounds.xmin, bounds.ymin, bounds.xmax, bounds.ymax,
                                     out_xmin, out_ymin, out_xmax, out_ymax, densify_points)

      unless result == 0
        Error.check(self.context)
      end

      Bounds.new(out_xmin.read_double, out_ymin.read_double, out_xmax.read_double, out_ymax.read_double)
    end

    # Transforms an array of {Coordinate coordinates}. Individual points that fail to transform
    # will have their components set to Infinity.
    #
    # @param array [Array<Coordinate>] Coordinates to transform
    # @param direction [PJ_DIRECTION] The direction of the transformation
    #
    # @return [Array<Coordinate>] Array of transformed coordinates
    def transform_array(coordinates, direction)
      coords_ptr = FFI::MemoryPointer.new(Api::PJ_COORD, coordinates.size)
      coordinates.each_with_index do |coordinate, i|
        pj_coord = Api::PJ_COORD.new(coords_ptr[i])
        pj_coord.to_ptr.__copy_from__(coordinate.to_ptr, Api::PJ_COORD.size)
      end

      int = Api.proj_trans_array(self, direction, coordinates.size, coords_ptr)
      unless int == 0
        Error.check(self.context)
      end

      result = Array.new(coordinates.size)
      0.upto(coordinates.size) do |i|
        pj_coord = Api::PJ_COORD.new(coords_ptr[i])
        result[i] = Coordinate.from_coord(pj_coord)
      end
      result
    end

    # Measure the internal consistency of a given transformation. The function performs n round trip
    # transformations starting in either the forward or reverse direction.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_roundtrip proj_roundtrip
    #
    # @param direction [PJ_DIRECTION] The starting direction of transformation
    # @param iterations [Integer] The number of roundtrip transformations
    # @param coordinate [Coordinate] The input coordinate
    #
    # @return [Double] The euclidean distance of the starting point coordinate and the last coordinate after n iterations back and forth.
    def roundtrip(direction, iterations, coordinate)
      Api.proj_roundtrip(self, direction, iterations, coordinate.pj_coord)
    end

    # Returns a new PJ object whose axis order is the one expected for visualization purposes
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_normalize_for_visualization proj_normalize_for_visualization
    #
    # @return [CoordinateOperation] A new CoordinateOperation or nil in case of error
    def normalize_for_visualization
      ptr = Api.proj_normalize_for_visualization(self.context, self)
      self.class.create_object(ptr, self.context)
    end

    # Return the operation used during the last invocation of Transformation#forward or Transformation#inverse
    #
    # @see }https://proj.org/development/reference/functions.html#c.proj_trans_get_last_used_operation proj_trans_get_last_used_operation
    #
    # @return [CoordinateOperation] The last used operation
    def last_used_operation
      ptr = Api.proj_trans_get_last_used_operation(self)
      self.class.create_object(ptr, self.context)
    end

    # Return whether a coordinate operation has a "ballpark" transformation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_has_ballpark_transformation proj_coordoperation_has_ballpark_transformation
    #
    # @return [Boolean]
    def ballpark_transformation?
      result = Api.proj_coordoperation_has_ballpark_transformation(Context.current, self)
      result == 1 ? true : false
    end

    # Returns the accuracy (in meters) of a coordinate operation.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_accuracy proj_coordoperation_get_accuracy
    #
    # @return [Double] The accuracy, or a negative value if unknown or in case of error.
    def accuracy
      Api.proj_coordoperation_get_accuracy(self.context, self)
    end

    # Returns the number of grids used by a CoordinateOperation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_grid_used_count proj_coordoperation_get_grid_used_count
    #
    # @return [Integer]
    def grid_count
      Api.proj_coordoperation_get_grid_used_count(self.context, self)
    end

    # Returns information about a Grid
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_grid_used proj_coordoperation_get_grid_used
    #
    # @param index [Integer] Grid index
    #
    # @return [Integer]
    def grid(index)
      out_short_name = FFI::MemoryPointer.new(:string)
      out_full_name = FFI::MemoryPointer.new(:string)
      out_package_name = FFI::MemoryPointer.new(:string)
      out_url = FFI::MemoryPointer.new(:string)
      out_direct_download  = FFI::MemoryPointer.new(:int)
      out_open_license = FFI::MemoryPointer.new(:int)
      out_available = FFI::MemoryPointer.new(:int)

      result = Api.proj_coordoperation_get_grid_used(self.context, self, index,
                                                     out_short_name, out_full_name, out_package_name,
                                                     out_url, out_direct_download ,
                                                     out_open_license, out_available)

      if result != 1
        Error.check(self.context)
      end

      name_ptr = out_short_name.read_pointer
      full_name_ptr = out_full_name.read_pointer
      package_name_ptr = out_package_name.read_pointer
      url_ptr = out_url.read_pointer
      downloadable_ptr = out_direct_download 
      open_license_ptr = out_open_license
      available_ptr = out_available

      unless name_ptr.null?
        Grid.new(name_ptr.read_string_to_null, self.context,
                 full_name: full_name_ptr.null? ? nil : full_name_ptr.read_string_to_null,
                 package_name: package_name_ptr.null? ? nil : package_name_ptr.read_string_to_null,
                 url: url_ptr.null? ? nil : url_ptr.read_string_to_null,
                 downloadable: downloadable_ptr.null? ? nil : downloadable_ptr.read_int == 1 ? true : false,
                 open_license: open_license_ptr.null? ? nil : open_license_ptr.read_int == 1 ? true : false,
                 available: available_ptr.null? ? nil : available_ptr.read_int == 1 ? true : false)
      end
    end

    # Return the parameters of a Helmert transformation as WKT1 TOWGS84 values
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_coordoperation_get_towgs84_values proj_coordoperation_get_towgs84_values
    #
    # @param error_if_incompatible [Boolean] If true an exception is thrown if the coordinate operation is not compatible with a WKT1 TOWGS84 representation
    #
    # @return [Array<Double>] Array of 7 numbers that represent translation, rotation and scale parameters.
    #                          Rotation and scale difference terms might be zero if the transformation only includes translation parameters
    def to_wgs84(error_if_incompatible = false)
      parameter_count = 7
      out_values = FFI::MemoryPointer.new(:double, parameter_count)
      Api.proj_coordoperation_get_towgs84_values(self.context, self, out_values, parameter_count, error_if_incompatible ? 1 : 0)
      out_values.read_array_of_double(parameter_count)
    end

    # Returns the number of steps in a concatenated operation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_concatoperation_get_step_count proj_concatoperation_get_step_count
    #
    # @return [Integer] The number of steps
    def step_count
      Api.proj_concatoperation_get_step_count(self.context, self)
    end

    # Returns a step of a concatenated operation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_concatoperation_get_step proj_concatoperation_get_step
    #
    # @param index [Integer] Index of the step
    #
    # @return [PjObject]
    def step(index)
      ptr = Api.proj_concatoperation_get_step(self.context, self, index)
      PjObject.create_object(ptr, self.context)
    end
  end
end
