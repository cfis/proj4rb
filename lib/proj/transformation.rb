module Proj
  # Transformations are {CoordinateOperationMixin coordinate operations} that
  # convert {Coordinate coordinates} from one {Crs} to another.
  # In Proj they are defined as operations that exert a change in reference frame
  # while {Conversion conversions } do not.
  class Transformation < PjObject
    include CoordinateOperationMixin

    # Create a Transformation
    #
    # @param context [Context] Context
    # @param name [String] Name of the transformation. Default is nil.
    # @param auth_name [String] Transformation authority name. Default is nil.
    # @param code [String] Transformation code. Default is nil.
    # @param source_crs [CoordinateSystem] Source CRS
    # @param target_crs [CoordinateSystem] Target CRS
    # @param interpolation_crs [CoordinateSystem] Interpolation. Default is nil
    # @param method_name [String] Method name. Default is nil.
    # @param method_auth_name [String] Method authority name. Default is nil.
    # @param method_code [String] Method code. Default is nil.
    # @param params [Array<Parameter>] Parameter descriptions
    # @param accuracy [Float] Accuracy of the transformation in meters. A negative value means unknown.
    #
    # @return [Transformation]
    def self.create(context, name: nil, auth_name: nil, code: nil,
                    source_crs:, target_crs:, interpolation_crs: nil,
                    method_name: nil, method_auth_name: nil, method_code: nil,
                    params:, accuracy:)

      params_ptr = FFI::MemoryPointer.new(Api::PJ_PARAM_DESCRIPTION, params.size)
      params.each_with_index do |param, i|
        param_description_target = Api::PJ_PARAM_DESCRIPTION.new(params_ptr[i])
        param_description_source = param.to_description
        param_description_target.to_ptr.__copy_from__(param_description_source.to_ptr, Api::PJ_PARAM_DESCRIPTION.size)
      end

      ptr = Api.proj_create_transformation(context, name, auth_name, code,
                                           source_crs, target_crs, interpolation_crs,
                                           method_name, method_auth_name, method_code,
                                           params.count, params_ptr, accuracy)
      self.create_object(ptr, context)
    end

    # Transforms a {Coordinate} from the source {Crs} to the target {Crs}. Coordinates should be expressed in
    # the units and axis order of the definition of the source CRS. The returned transformed coordinate will
    # be in the units and axis order of the definition of the target CRS.
    #
    # For most geographic Crses, the units will be in degrees. For geographic CRS defined by the EPSG authority,
    # the order of coordinates is latitude first, longitude second. When using a PROJ initialization string,
    # on contrary, the order will be longitude first, latitude second.
    #
    # For projected CRS, the units may vary (metre, us-foot, etc..).
    #
    # For projected CRS defined by the EPSG authority, and with EAST / NORTH directions, the axis order might be
    # easting first, northing second, or the reverse. When using a PROJ string, the order will be
    # easting first, northing second, except if the +axis parameter modifies it.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_create_crs_to_crs_from_pj
    # @see  https://proj.org/development/reference/functions.html#c.proj_create_crs_to_crs proj_create_crs_to_crs
    #
    # @param source [Crs, String] The source Crs. See the Crs documentation for the string format
    # @param target [Crs, String] The target Crs. See the Crs documentation for the string format
    # @param area [Area] If an area is specified a more accurate transformation between two given systems can be chosen
    # @param context [Context]
    # @param authority [String] Restricts the authority of coordinate operations looked up in the database
    # @param accuracy [Float] Sets the minimum desired accuracy (in metres) of the candidate coordinate operations
    # @param allow_ballpark [Boolean] Set to false to disallow the use of Ballpark transformation in the candidate coordinate operations.
    # @param only_best [Boolean] Set to true to cause PROJ to error out if the best transformation cannot be used. Requires Proj 9.2 and higher
    #
    # @return [Transformation] A new transformation
    def initialize(source, target, context=nil,
                   area: nil, authority: nil, accuracy: nil, allow_ballpark: nil, only_best: nil, force_over: nil)

      context ||= Context.current

      options = {"AUTHORITY": authority,
                 "ACCURACY": accuracy.nil? ? nil : accuracy.to_s,
                 "ALLOW_BALLPARK": allow_ballpark.nil? ? nil : (allow_ballpark ? "YES" : "NO"),
                 "ONLY_BEST": only_best.nil? ? nil : (only_best ? "YES" : "NO"),
                 "FORCE_OVER": force_over.nil? ? nil : (force_over ? "YES" : "NO")}
      options_ptr = create_options_pointer(options)

      ptr = if source.is_a?(Crs) && target.is_a?(Crs)
              if Api.method_defined?(:proj_create_crs_to_crs_from_pj)
                Api.proj_create_crs_to_crs_from_pj(context, source, target, area, options_ptr)
              else
                Api.proj_create_crs_to_crs(context, source.definition, target.definition, area)
              end
            else
              Api.proj_create_crs_to_crs(context, source, target, nil)
            end

      if ptr.null?
        Error.check_context(context)
        # If that does not raise an error then no operation was found
        raise(Error, "No operation found matching criteria")
      end

      super(ptr, context)
    end
  end
end