# encoding: UTF-8
module Proj
  class PjObject
    # @!visibility private
    def self.create_object(pointer, context)
      unless pointer.null?
        # Get the proj type
        type = Api.proj_get_type(pointer)

        # If we can create a derived classes, but we do not want to call their
        # initializers since we already have a valid PROJ object that we
        # just have to wrap
        instance = case type
                   when :PJ_TYPE_CRS, :PJ_TYPE_GEODETIC_CRS, :PJ_TYPE_GEOCENTRIC_CRS,
                        :PJ_TYPE_GEOGRAPHIC_2D_CRS, :PJ_TYPE_GEOGRAPHIC_3D_CRS,
                        :PJ_TYPE_GEOGRAPHIC_CRS, :PJ_TYPE_VERTICAL_CRS,:PJ_TYPE_PROJECTED_CRS,
                        :PJ_TYPE_COMPOUND_CRS, :PJ_TYPE_TEMPORAL_CRS, :PJ_TYPE_ENGINEERING_CRS,
                        :PJ_TYPE_BOUND_CRS, :PJ_TYPE_OTHER_CRS
                     Crs.allocate
                   when :PJ_TYPE_CONVERSION, :PJ_TYPE_OTHER_COORDINATE_OPERATION, :PJ_TYPE_CONCATENATED_OPERATION
                     Conversion.allocate
                   when :PJ_TYPE_TRANSFORMATION
                     Transformation.allocate
                   when :PJ_TYPE_TEMPORAL_DATUM, :PJ_TYPE_ENGINEERING_DATUM, :PJ_TYPE_PARAMETRIC_DATUM,
                        :PJ_TYPE_GEODETIC_REFERENCE_FRAME, :PJ_TYPE_DYNAMIC_GEODETIC_REFERENCE_FRAME,
                        :PJ_TYPE_VERTICAL_REFERENCE_FRAME, :PJ_TYPE_DYNAMIC_VERTICAL_REFERENCE_FRAME
                     Datum.allocate
                   when :PJ_TYPE_DATUM_ENSEMBLE
                     DatumEnsemble.allocate
                   when :PJ_TYPE_ELLIPSOID
                     Ellipsoid.allocate
                   when :PJ_TYPE_PRIME_MERIDIAN
                     PrimeMeridian.allocate
                   else
                     PjObject.allocate
                   end

        # Now setup the instance variables
        instance.instance_variable_set(:@pointer, pointer)
        instance.instance_variable_set(:@context, context)

        instance
      end
    end

    # Instantiates an object from a database lookup
    #
    # @param auth_name [String] Authority name (must not be nil)
    # @param code  [String] Object code (must not be nil)
    # @param category [PJ_CATEGORY] A PJ_CATEGORY enum value
    # @param use_alternative_grid_names [Boolean] Whether PROJ alternative grid names should be substituted to the official grid names. Only used on transformations. Defaults to false
    # @param context [Context] Context. If nil the current context is used
    #
    # @return [PjObject] Crs or Transformation
    def self.create_from_database(auth_name, code, category, use_alternative_grid_names = false, context = nil)
      context ||= Context.current
      ptr = Api.proj_create_from_database(context, auth_name, code, category,
                                          use_alternative_grid_names ? 1 : 0, nil)

      create_object(ptr, context)
    end

    # Instantiates an object from a WKT string.
    #
    # @param wkt [String] WKT string (must not be nil)
    # @param context [Context] Context. If nil the current context is used
    # @param options [Hash] Currently supported options are:
    #                          STRICT = True/False When set to YES, strict validation will be enabled.
    #                          UNSET_IDENTIFIERS_IF_INCOMPATIBLE_DEF = True/False Defaults to True.
    # @return [PjObject] Crs or Transformation
    def self.create_from_wkt(wkt, context = nil, options = nil)
      out_warnings = FFI::MemoryPointer.new(:pointer)
      out_grammar_errors = FFI::MemoryPointer.new(:pointer)

      ptr = Api.proj_create_from_wkt(context, wkt, nil, out_warnings, out_grammar_errors)

      warnings = Strings.new(out_warnings.read_pointer)
      errors = Strings.new(out_grammar_errors.read_pointer)

      unless errors.empty?
        raise(RuntimeError, errors.join(". "))
      end

      unless warnings.empty?
        warn(warnings.join(". "))
      end

      create_object(ptr, context)
    end

    # Return a list of objects by their name
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_create_from_name proj_create_from_name
    #
    # @param name [String] Search value, must be at least two characters
    # @param context [Context] Context. If nil the current context is used
    # @param auth_name [String] Authority name or nil for all authorities. Default is nil
    # @param types [Array<PJ_TYPE>] Types of objects to search for or nil for all types. Default is nil
    # @param approximate_match  [Boolean] Whether approximate name identification is allowed. Default is false
    # @param limit [Integer] The maximum number of results to return, use 0 for all results. Default is 0
    #
    # @return [PjObjects] Found objects
    def self.create_from_name(name, context, auth_name: nil, types: nil, approximate_match: false, limit: 0)
      if types
        types_ptr = FFI::MemoryPointer.new(Api::PJ_TYPE.native_type, types.size)
        types_ptr.write_array_of_int(types.map { |symbol| Api::PJ_TYPE[symbol]})
        types_count = types.size
      else
        types_ptr = nil
        types_count = 0
      end

      ptr = Api.proj_create_from_name(context, auth_name, name, types_ptr, types_count, approximate_match ? 1 : 0, limit, nil)
      PjObjects.new(ptr, context)
    end

    # Instantiates an conversion from a string. The string can be:
    #
    # * proj-string,
    # * WKT string,
    # * object code (like "EPSG:4326", "urn:ogc:def:crs:EPSG::4326", "urn:ogc:def:coordinateOperation:EPSG::1671"),
    # * Object name. e.g "WGS 84", "WGS 84 / UTM zone 31N". In that case as uniqueness is not guaranteed, heuristics are applied to determine the appropriate best match.
    # * OGC URN combining references for compound coordinate reference systems (e.g "urn:ogc:def:crs,crs:EPSG::2393,crs:EPSG::5717" or custom abbreviated syntax "EPSG:2393+5717"),
    # * OGC URN combining references for concatenated operations (e.g. "urn:ogc:def:coordinateOperation,coordinateOperation:EPSG::3895,coordinateOperation:EPSG::1618")
    # * PROJJSON string. The jsonschema is at https://proj.org/schemas/v0.4/projjson.schema.json (added in 6.2)
    # * compound CRS made from two object names separated with " + ". e.g. "WGS 84 + EGM96 height" (added in 7.1)
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_create proj_create
    #
    # @param value [String]. See above
    #
    # @return [PjObject] Crs or Transformation
    def self.create(value, context=nil)
      ptr = Api.proj_create(context || Context.current, value)

      if ptr.null?
        Error.check(self.context)
      end

      create_object(ptr, context)
    end

    def self.finalize(pointer)
      proc do
        Api.proj_destroy(pointer)
      end
    end

    def initialize(pointer, context=nil)
      if pointer.null?
        raise(Error, "Cannot create a PjObject with a null pointer")
      end
      @pointer = pointer
      @context = context
      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    def initialize_copy(original)
      ObjectSpace.undefine_finalizer(self)

      super

      @pointer = Api.proj_clone(original.context, original)

      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    # Assign a new context to this object
    #
    # @param [Context] The context to assign to this object
    def context=(value)
      Api.proj_assign_context(self, value)
    end

    def to_ptr
      @pointer
    end

    def context
      @context || Context.current
    end

    def errno
      Api.proj_errno(self)
    end

    # Returns whether an object is deprecated
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_is_deprecated proj_is_deprecated
    #
    # @return [Boolean] True if the object is deprecated, otherwise false
    def deprecated?
      result = Api.proj_is_deprecated(self)
      result == 1 ? true : false
    end

    # Return whether two objects are equivalent. For versions 6.3.0 and higher
    # the check may use using the proj database to check for name aliases
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_is_equivalent_to proj_is_equivalent_to
    # @see https://proj.org/development/reference/functions.html#c.proj_is_equivalent_to_with_ctx proj_is_equivalent_to_with_ctx
    #
    # @param other [PjObject] Object to compare to
    # @param comparison [PJ_COMPARISON_CRITERION] Comparison criterion
    #
    # @return [Boolean] True if the objects are equivalent, otherwise false
    def equivalent_to?(other, comparison)
      result = if Api::PROJ_VERSION < Gem::Version.new('6.3.0')
                 Api.proj_is_equivalent_to(self, other, comparison)
               else
                 Api.proj_is_equivalent_to_with_ctx(self.context, self, other, comparison)
               end
      result == 1 ? true : false
    end

    #  Returns the current error-state of this object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_errno proj_errno
    #
    # @return [Integer] An non-zero error codes indicates an error either with the transformation setup or during a transformation
    def errorno
      Api.proj_errno(self)
    end

    # Get information about this object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_pj_info proj_pj_info
    #
    # @return [PJ_PROJ_INFO]
    def info
      Api.proj_pj_info(self)
    end

    # Short ID of the operation the PJ object is based on, that is, what comes after the +proj=
    # in a proj-string, e.g. "merc".
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_pj_info proj_pj_info
    #
    # @return [String]
    def id
      self.info[:id]
    end

    # Long description of the operation the PJ object is based on, e.g. "Mercator Cyl, Sph&Ell lat_ts="
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_pj_info proj_pj_info
    #
    # @return [String]
    def description
      self.info[:description] ? self.info[:description].force_encoding('UTF-8') : nil
    end

    # The proj-string that was used to create the PJ object with, e.g. "+proj=merc +lat_0=24 +lon_0=53 +ellps=WGS84"
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_pj_info proj_pj_info
    #
    # @return [String]
    def definition
      self.info[:definition] ? self.info[:definition].force_encoding('UTF-8') : nil
    end

    # Returns true if an an inverse mapping of the defined operation exists, otherwise false
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_pj_info proj_pj_info
    #
    # @return [Boolean]
    def has_inverse?
      self.info[:has_inverse] == 1 ? true : false
    end

    # Expected accuracy of the transformation. -1 if unknown
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_pj_info proj_pj_info
    #
    # @return [Double]
    def accuracy
      self.info[:accuracy]
    end

    # Return the type of an object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_type proj_get_type
    #
    # @return [PJ_TYPE]
    def proj_type
      Api.proj_get_type(self)
    end

    # Returns the name of an object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_name proj_get_name
    #
    # @return [String]
    def name
      Api.proj_get_name(self)&.force_encoding('UTF-8')
    end

    # Returns the authority name / codespace of an identifier of an object.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_id_auth_name proj_get_id_auth_name
    #
    # @param index [Integer] Index of the identifier. 0 is for the first identifier. Default is 0.
    #
    # @return [String]
    def auth_name(index=0)
      Api.proj_get_id_auth_name(self, index).force_encoding('UTF-8')
    end

    # Get the code of an identifier of an object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_id_code proj_get_id_code
    #
    # @param index [Integer] Index of the identifier. 0 is the first identifier. Default is 0
    #
    # @return [String] The code or nil in case of error or missing name
    def id_code(index=0)
      Api.proj_get_id_code(self, index)
    end

    # Get the remarks of an object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_remarks proj_get_remarks
    #
    # @return [String] Remarks  or nil in case of error
    def remarks
      Api.proj_get_remarks(self)
    end

    # Get the scope of an object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_scope proj_get_scope
    #
    # @return [String] Scope or nil in case of error or a missing scope
    def scope
      Api.proj_get_scope(self)
    end

    def auth(index=0)
      "#{self.auth_name(index)}:#{self.id_code(index)}"
    end

    # Return the area of use of an object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_area_of_use proj_get_area_of_use
    #
    # @return [Area] In case of multiple usages, this will be the one of first usage.
    def area_of_use
      p_name = FFI::MemoryPointer.new(:pointer)
      p_west_lon_degree = FFI::MemoryPointer.new(:double)
      p_south_lat_degree = FFI::MemoryPointer.new(:double)
      p_east_lon_degree = FFI::MemoryPointer.new(:double)
      p_north_lat_degree = FFI::MemoryPointer.new(:double)

      result = Api.proj_get_area_of_use(self.context, self,
                                        p_west_lon_degree, p_south_lat_degree, p_east_lon_degree, p_north_lat_degree,
                                        p_name)
      if result != 0
        Error.check(self.context)
      end

      name = p_name.read_pointer.read_string_to_null.force_encoding('utf-8')
      Area.new(west_lon_degree: p_west_lon_degree.read_double,
               south_lat_degree: p_south_lat_degree.read_double,
               east_lon_degree: p_east_lon_degree.read_double,
               north_lat_degree: p_north_lat_degree.read_double,
               name: name)
    end

    # Return the base CRS of a BoundCRS or a DerivedCRS/ProjectedCRS, or the source CRS of a
    # CoordinateOperation, or the CRS of a CoordinateMetadata.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_source_crs proj_get_source_crs
    #
    # @return [Crs]
    def source_crs
      ptr = Api.proj_get_source_crs(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Return the hub CRS of a BoundCRS or the target CRS of a CoordinateOperation
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_target_crs proj_get_target_crs
    #
    # @return [Crs]
    def target_crs
      ptr = Api.proj_get_target_crs(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Calculate various cartographic properties, such as scale factors, angular distortion and
    # meridian convergence. Depending on the underlying projection values will be
    # calculated either numerically (default) or analytically. The function also calculates
    # the partial derivatives of the given coordinate.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_factors proj_factors
    #
    # @param coordinate [Coordinate] Input geodetic coordinate in radians
    #
    # @return [PJ_FACTORS]
    def factors(coordinate)
      Api.proj_factors(self, coordinate)
    end

    # Return a list of non-deprecated objects related to the passed one
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_non_deprecated proj_get_non_deprecated
    #
    # @return [Array] Array of objects
    def non_deprecated
      ptr = Api.proj_get_non_deprecated(self.context, self)
      PjObjects.new(ptr, self.context)
    end

    # Calculate geodesic distance between two points in geodetic coordinates. The calculated distance is between
    # the two points located on the ellipsoid. Note that the axis order of the transformation object
    # is not taken into account, so even though a CRS object comes with axis ordering
    # latitude/longitude coordinates used in this function should be reordered as longitude/latitude.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_lp_dist proj_lp_dist
    #
    # @param coord1 [Coordinate] Coordinate of first point. Must be lat/long in radians
    # @param coord2 [Coordinate] Coordinate of second point. Must be lat/long in radians
    #
    # @return [Double] Distance between the coordinates in meters
    def lp_distance(coord1, coord2)
      Api.proj_lp_dist(self, coord1, coord2)
    end

    # Calculate geodesic distance between two points in geodetic coordinates. Similar to
    # PjObject#lp_distance but also takes the height above the ellipsoid into account.
    #
    # Note that the axis order of the transformation object is not taken into account, so even though
    # a CRS object comes with axis ordering latitude/longitude coordinates used in this function
    # should be reordered as longitude/latitude.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_lpz_dist proj_lpz_dist
    #
    # @param coord1 [Coordinate] Coordinate of first point. Must be lat/long in radians
    # @param coord2 [Coordinate] Coordinate of second point. Must be lat/long in radians
    #
    # @return [Double] Distance between the coordinates in meters
    def lpz_distance(coord1, coord2)
      Api.proj_lpz_dist(self, coord1, coord2)
    end

    # Calculate the 2-dimensional euclidean between two projected coordinates
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_xy_dist proj_xy_dist
    #
    # @param coord1 [Coordinate] Coordinate of first point
    # @param coord2 [Coordinate] Coordinate of second point
    #
    # @return [Double] Distance between the coordinates in meters
    def xy_distance(coord1, coord2)
      Api.proj_xy_dist(coord1, coord2)
    end

    # Calculate the 2-dimensional euclidean between two projected coordinates. Similar to
    # PjObject#xy_distance but also takes height into account.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_xyz_dist proj_xyz_dist
    #
    # @param coord1 [Coordinate] Coordinate of first point
    # @param coord2 [Coordinate] Coordinate of second point
    #
    # @return [Double] Distance between the coordinates in meters
    def xyz_distance(coord1, coord2)
      Api.proj_xyz_dist(coord1, coord2)
    end

    # Calculate the geodesic distance as well as forward and reverse azimuth between two points on the ellipsoid.
    #
    # Note that the axis order of the transformation object is not taken into account, so even though
    # a CRS object comes with axis ordering latitude/longitude coordinates used in this function
    # should be reordered as longitude/latitude.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_geod proj_geod
    #
    # @param coord1 [Coordinate] Coordinate of first point. Must be lat/long in radians
    # @param coord2 [Coordinate] Coordinate of first point. Must be lat/long in radians
    #
    # @return [Coordinate] The first value is the distance between coord1 and coord2 in meters,
    # the second is the forward azimuth, the third value the reverse azimuth and the fourth value is unused.
    def geod_distance(coord1, coord2)
      ptr = Api.proj_geod(self, coord1, coord2)
      Coordinate.from_coord(ptr)
    end

    # Returns if an operation expects input in radians
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_angular_input proj_angular_input
    #
    # @param direction []PJ_DIRECTION] Direction of transformation
    def angular_input?(direction)
      result = Api.proj_angular_input(self, direction)
      result == 1 ? true : false
    end

    # Check if an operation returns output in radians
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_angular_output proj_angular_output
    #
    # @param direction []PJ_DIRECTION] Direction of transformation
    def angular_output?(direction)
      result = Api.proj_angular_output(self, direction)
      result == 1 ? true : false
    end

    # Returns if an operation expects input in degrees
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_degree_input proj_degree_input
    #
    # @param direction []PJ_DIRECTION] Direction of transformation
    def degree_input?(direction)
      result = Api.proj_degree_input(self, direction)
      result == 1 ? true : false
    end

    # Check if an operation returns output in degrees
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_degree_output proj_degree_output
    #
    # @param direction []PJ_DIRECTION] Direction of transformation
    def degree_output?(direction)
      result = Api.proj_degree_output(self, direction)
      result == 1 ? true : false
    end

    # Returns the proj representation string for this object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_as_proj_string proj_as_proj_string
    #
    # @param proj_version [PJ_PROJ_STRING_TYPE] The proj version. Defaults to :PJ_PROJ_5
    # @param use_approx_tmerc [Boolean] True adds the +approx flag to +proj=tmerc or +proj=utm. Defaults to false
    # @param multiline [Boolean] Specifies if output span multiple lines. Defaults to false.
    # @param indentation_width [Integer] Specifies the indentation level. Defaults to 2.
    # @param max_line_length [Integer] Specifies the max line length level. Defaults to 80.
    #
    # @return [String]
    def to_proj_string(proj_version=:PJ_PROJ_5, use_approx_tmerc: false, multiline: false,
                                                indentation_width: 2, max_line_length: 80)

      options = ["USE_APPROX_TMERC=#{use_approx_tmerc ? "YES" : "NO"}",
                 "MULTILINE=#{multiline ? "YES" : "NO"}",
                 "INDENTATION_WIDTH=#{indentation_width}",
                 "MAX_LINE_LENGTH=#{max_line_length}"]

      options_ptr_array = options.map do |option|
        FFI::MemoryPointer.from_string(option)
      end

      # Add extra item at end for null pointer
      options_ptr = FFI::MemoryPointer.new(:pointer, options.size + 1)
      options_ptr.write_array_of_pointer(options_ptr_array)

      Api.proj_as_proj_string(self.context, self, proj_version, options_ptr).force_encoding('UTF-8')
    end

    # Returns the json representation for this object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_as_projjson proj_as_projjson
    #
    # @param multiline [Boolean] Specifies if output span multiple lines. Defaults to true.
    # @param indentation_width [Integer] Specifies the indentation level. Defaults to 2.
    #
    # @return [String]
    def to_json(multiline: true, indentation_width: 2)
      options = ["MULTILINE=#{multiline ? "YES" : "NO"}",
                 "INDENTATION_WIDTH=#{indentation_width}"]

      options_ptr_array = options.map do |option|
        FFI::MemoryPointer.from_string(option)
      end

      # Add extra item at end for null pointer
      options_ptr = FFI::MemoryPointer.new(:pointer, options.size + 1)
      options_ptr.write_array_of_pointer(options_ptr_array)

      Api.proj_as_projjson(self.context, self, options_ptr).force_encoding('UTF-8')
    end

    # Returns the wkt representation for this object
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_as_wkt proj_as_wkt
    #
    # @param wkt_type [PJ_WKT_TYPE] WKT version to output. Defaults to PJ_WKT2_2018
    # @param multiline [Boolean] Specifies if output span multiple lines. Defaults to true.
    # @param indentation_width [Integer] Specifies the indentation level. Defaults to 4.
    #
    # @return [String] wkt
    def to_wkt(wkt_type=:PJ_WKT2_2018, multiline: true, indentation_width: 4)
      options = ["MULTILINE=#{multiline ? "YES" : "NO"}",
                 "INDENTATION_WIDTH=#{indentation_width}",
                 "OUTPUT_AXIS=AUTO",
                 "STRICT=YES",
                 "ALLOW_ELLIPSOIDAL_HEIGHT_AS_VERTICAL_CRS=NO",
                 "ALLOW_LINUNIT_NODE=YES"]

      options_ptr_array = options.map do |option|
        FFI::MemoryPointer.from_string(option)
      end

      # Add extra item at end for null pointer
      options_ptr = FFI::MemoryPointer.new(:pointer, options.size + 1)
      options_ptr.write_array_of_pointer(options_ptr_array)

      Api.proj_as_wkt(self.context, self, wkt_type, options_ptr)&.force_encoding('UTF-8')
    end

    # Returns the string representation for this object
    #
    # @return [String] String
    def to_s
      "#<#{self.class.name} - #{name}, #{proj_type}>"
    end
  end
end
