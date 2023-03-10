module Proj
  # Transformations are {CoordinateOperationMix coordinate operations} that
  # convert {Coordinate coordinates} from one {Crs} to another.
  # In Proj they are defined as operations that exert a change in reference frame
  # while {Conversion conversions } do not.
  class Transformation < PjObject
    include CoordinateOperationMixin

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
    # @param source [Crs | String] The source Crs. See the Crs documentation for the string format
    # @param target [Crs | String] The target Crs. See the Crs documentation for the string format
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
                 "FORCE_OVER": force_over.nil? ? nil : (force_over ? "YES" : "NO")}.compact

      options_ptr_array = options.map do |key, value|
        FFI::MemoryPointer.from_string("#{key}=#{value}")
      end

      # Add extra item at end for null pointer
      options_ptr = FFI::MemoryPointer.new(:pointer, options.size + 1)
      options_ptr.write_array_of_pointer(options_ptr_array)

      pointer = if source.is_a?(Crs) && target.is_a?(Crs)
                  if Api.method_defined?(:proj_create_crs_to_crs_from_pj)
                    Api.proj_create_crs_to_crs_from_pj(context, source, target, area, options_ptr)
                  else
                    Api.proj_create_crs_to_crs(context, source.definition, target.definition, area)
                  end
                else
                  Api.proj_create_crs_to_crs(context, source, target, nil)
                end

      if pointer.null?
        Error.check_context(context)
        # If that does not raise an error then no operation was found
        raise(Error, "No operation found matching criteria")
      end

      super(pointer, context)
    end
  end
end