module Proj
  CelestialBody = Struct.new(:auth_name, :name)

  # This class provides access the Proj SQLite database called proj.db. The database
  # stores transformation information that must be accessible for the library to work properly.
  #
  # @see https://proj.org/resource_files.html#proj-db
  class Database
    attr_reader :context

    # Create a new database instance to query the Proj database
    #
    # @param context [Context] A proj Context
    #
    # @return [Database]
    def initialize(context)
      @context = context
      figure_path
    end

    # Helper method that tries to locate the Proj coordinate database (proj.db)
    def figure_path
      if !path
        self.database_path = Config.instance.db_path
      end
    end

    # Returns the path the Proj database
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_database_path proj_context_get_database_path
    #
    # return [String]
    def path
      if Api.method_defined?(:proj_context_get_database_path)
        Api.proj_context_get_database_path(self.context)
      end
    end

    # Sets the path to the Proj database
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_set_database_path proj_context_set_database_path
    #
    # @param value [String] Path to the proj database
    #
    # @return [Database] Returns reference to the current database instance
    def path=(value)
      result = Api.proj_context_set_database_path(self.context, value, nil, nil)
      unless result == 1
        Error.check(self.context)
      end
      self
    end

    # Returns SQL statements to run to initiate a new valid auxiliary empty database.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_database_structure proj_context_get_database_structure
    #
    # @return [Array<Strings>] List of sql statements
    def structure
      ptr = Api.proj_context_get_database_structure(self.context, nil)
      Strings.new(ptr)
    end

    # Return a metadata from the database.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_context_get_database_metadata proj_context_get_database_metadata
    #
    # @param key [String] The name of the metadata item. Must not be nil
    #                       Available keys:
    #                         DATABASE.LAYOUT.VERSION.MAJOR
    #                         DATABASE.LAYOUT.VERSION.MINOR
    #                         EPSG.VERSION
    #                         EPSG.DATE
    #                         ESRI.VERSION
    #                         ESRI.DATE
    #                         IGNF.SOURCE
    #                         IGNF.VERSION
    #                         IGNF.DATE
    #                         NKG.SOURCE
    #                         NKG.VERSION
    #                         NKG.DATE
    #                         PROJ.VERSION
    #                         PROJ_DATA.VERSION
    #
    # @return [String] Returned metadata
    def metadata(key)
      Api.proj_context_get_database_metadata(self.context, key)
    end

    # Returns the set of authority codes of the given object type.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_codes_from_database proj_get_codes_from_database
    #
    # @param auth_name [String] Authority name. Must not be nil.
    # @param type [PJ_TYPE] Object type.
    # @param allow_deprecated [Boolean] Specifies if deprecated objects should be returned. Default is false.
    #
    # @return [Strings] Returned authority codes
    def codes(auth_name, type, allow_deprecated = false)
      ptr = Api.proj_get_codes_from_database(self.context, auth_name, type, allow_deprecated ? 1 : 0)
      Strings.new(ptr)
    end

    # Return a list of authorities used in the database
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_authorities_from_database proj_get_authorities_from_database
    #
    # @return [Array<Strings>] List of authorities
    def authorities
      ptr = Api.proj_get_authorities_from_database(self.context)
      Strings.new(ptr)
    end

    # Enumerate CRS infos from the database, taking into account various criteria.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_crs_info_list_from_database proj_get_crs_info_list_from_database
    #
    # @param auth_name [String] Authority name. Use nil to specify all authorities
    # @param parameters [Parameters] Parameters to specify search criteria. May be nil
    #
    # @return [Array<CrsInfo>] Returned crs infos
    def crs_info(auth_name = nil, parameters = nil)
      out_result_count = FFI::MemoryPointer.new(:int)
      ptr = Api.proj_get_crs_info_list_from_database(self.context, auth_name, parameters, out_result_count)

      result = out_result_count.read_int.times.map do |index|
        index_ptr = ptr + (index * FFI::Pointer::SIZE)
        struct = Api::PROJ_CRS_INFO.new(index_ptr.read_pointer)
        CrsInfo.from_proj_crs_info(struct)
      end

      Api.proj_crs_info_list_destroy(ptr)
      result
    end

    # Returns information about a Grid from the database
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_grid_get_info_from_database proj_grid_get_info_from_database
    #
    # @param name [String] The name of the grid
    #
    # @return [Grid]
    def grid(name)
      out_full_name = FFI::MemoryPointer.new(:string)
      out_package_name = FFI::MemoryPointer.new(:string)
      out_url = FFI::MemoryPointer.new(:string)
      out_downloadable = FFI::MemoryPointer.new(:int)
      out_open_license = FFI::MemoryPointer.new(:int)
      out_available = FFI::MemoryPointer.new(:int)

      result = Api.proj_grid_get_info_from_database(self.context, name,
                                                    out_full_name, out_package_name, out_url,
                                                    out_downloadable, out_open_license, out_available)

      if result != 1
        Error.check(self.context)
      end

      full_name_ptr = out_full_name.read_pointer
      package_name_ptr = out_package_name.read_pointer
      url_ptr = out_url.read_pointer

      downloadable_ptr = out_downloadable
      open_license_ptr = out_open_license
      available_ptr = out_available

      unless full_name_ptr.null?
        full_name = full_name_ptr.read_string_to_null
        package_name = package_name_ptr.read_string_to_null
        url = url_ptr.read_string_to_null

        downloadable = downloadable_ptr.read_int == 1 ? true : false
        open_license = open_license_ptr.read_int == 1 ? true : false
        available = available_ptr.read_int == 1 ? true : false

        Grid.new(name, self.context,
                 full_name: full_name, package_name: package_name,
                 url: url ? URI(url) : nil,
                 downloadable: downloadable, open_license: open_license, available: available)
      end
    end

    # Returns a list of geoid models available
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_geoid_models_from_database proj_get_geoid_models_from_database
    #
    # @param authority [String] Authority name into which the object will be inserted. Must not be nil
    # @param code [Integer] Code with which the object will be inserted.Must not be nil
    #
    # @return [Strings] List of insert statements
    def geoid_models(authority, code)
      ptr = Api.proj_get_geoid_models_from_database(self.context, authority, code, nil)
      Strings.new(ptr)
    end

    # Returns a list of celestial bodies from the database
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_celestial_body_list_from_database proj_get_celestial_body_list_from_database
    #
    # @param authority [String] Authority name, used to restrict the search. Set to nil for all authorities.
    #
    # @return [Array<CelestialBody>] List of insert statements
    def celestial_bodies(authority = nil)
      out_result_count = FFI::MemoryPointer.new(:int)
      ptr = Api.proj_get_celestial_body_list_from_database(self.context, authority, out_result_count)

      body_ptrs = ptr.read_array_of_pointer(out_result_count.read_int)
      result = body_ptrs.map do |body_ptr|
        # First read the pointer to a structure
        struct = Api::ProjCelestialBodyInfo.new(body_ptr)

        # Now map this to a Ruby Struct
        CelestialBody.new(struct[:auth_name], struct[:name])
      end

      Api.proj_celestial_body_list_destroy(ptr)

      result
    end

    # Return the name of the celestial body of the specified object.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_celestial_body_name proj_get_celestial_body_name
    #
    # @param object [PjObject] Object of type CRS, Datum or Ellipsoid. Must not be nil.
    #
    # @return [String] The name of the celestial body or nil
    def celestial_body_name(object)
      Api.proj_get_celestial_body_name(self.context, object)
    end

    # Suggests a database code for the specified object.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_suggests_code_for proj_suggests_code_for
    #
    # @param object [PjObject] Object for which to suggest a code.
    # @param authority [String]  Authority name into which the object will be inserted.
    # @param numeric_code [Boolean] Whether the code should be numeric, or derived from the object name.
    #
    # @return [String] The suggested code
    def suggest_code_for(object, authority, numeric_code)
      ptr = Api.proj_suggests_code_for(self.context, object, authority, numeric_code ? 1 : 0, nil)
      result = ptr.read_string_to_null
      Api.proj_string_destroy(ptr)
      result
    end

    # Returns a list of units from the database
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_units_from_database proj_get_units_from_database
    #
    # @param auth_name [String] Authority name, used to restrict the search. Or nil for all authorities.
    # @param category [String] Filter by category, if this parameter is not nil. Category is one of "linear", "linear_per_time", "angular", "angular_per_time", "scale", "scale_per_time" or "time
    # @param allow_deprecated [Boolean] Whether deprecated units should also be returned. Default false.
    #
    # @return [Array<Unit>] Array of units
    def units(auth_name, category = nil, allow_deprecated = false)
      Unit.list(auth_name: auth_name, category: category, allow_deprecated: allow_deprecated)
    end
  end
end
