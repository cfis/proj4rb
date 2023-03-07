module Proj
  module Api
    # Comparison criteria
    PJ_COMPARISON_CRITERION = enum(:PJ_COMP_STRICT, # All properties are identical
                                   :PJ_COMP_EQUIVALENT, # The objects are equivalent for the purpose of coordinate operations. They can differ by the name of their objects, identifiers, other metadata. Parameters may be expressed in different units, provided that the value is (with some tolerance) the same once expressed in a common unit.
                                   :PJ_COMP_EQUIVALENT_EXCEPT_AXIS_ORDER_GEOGCRS) # Same as EQUIVALENT, relaxed with an exception that the axis order of the base CRS of a DerivedCRS/ProjectedCRS or the axis order of a GeographicCRS is ignored. Only to be used with DerivedCRS/ProjectedCRS/GeographicCRS

    #Guessed WKT "dialect"
    PJ_GUESSED_WKT_DIALECT = enum(:PJ_GUESSED_WKT2_2019,
                                  :PJ_GUESSED_WKT2_2018,
                                  :PJ_GUESSED_WKT2_2015,
                                  :PJ_GUESSED_WKT1_GDAL,
                                  :PJ_GUESSED_WKT1_ESRI,
                                  :PJ_GUESSED_NOT_WKT)

    # Base methods
    attach_function :proj_clone, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_get_name, [:PJ], :string
    attach_function :proj_get_id_auth_name, [:PJ, :int], :string
    attach_function :proj_get_id_code, [:PJ, :int], :string
    attach_function :proj_get_remarks, [:PJ], :string
    attach_function :proj_get_scope, [:PJ], :string
    attach_function :proj_get_type, [:PJ], PJ_TYPE
    attach_function :proj_is_crs, [:PJ], :bool
    attach_function :proj_is_equivalent_to, [:PJ, :PJ, PJ_COMPARISON_CRITERION], :int
    attach_function :proj_is_deprecated, [:PJ], :int
    attach_function :proj_get_source_crs, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_get_target_crs, [:PJ_CONTEXT, :PJ], :PJ

    # Area
    attach_function :proj_area_create, [], :PJ_AREA
    attach_function :proj_area_set_bbox, [:PJ_AREA, :double, :double, :double, :double], :void
    attach_function :proj_get_area_of_use, [:PJ_CONTEXT, :PJ, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
    attach_function :proj_area_destroy, [:PJ_AREA], :void

    # Export to various formats
    attach_function :proj_as_wkt, [:PJ_CONTEXT, :PJ, PJ_WKT_TYPE, :pointer], :string
    attach_function :proj_as_proj_string, [:PJ_CONTEXT, :PJ, PJ_PROJ_STRING_TYPE, :pointer], :string

    # String List
    typedef :pointer, :PROJ_STRING_LIST
    attach_function :proj_string_list_destroy, [:PROJ_STRING_LIST], :void

    callback :proj_file_finder, [:PJ_CONTEXT, :string, :pointer], :pointer
    attach_function :proj_context_set_file_finder, [:PJ_CONTEXT, :proj_file_finder, :pointer], :void
    attach_function :proj_context_set_search_paths, [:PJ_CONTEXT, :int, :pointer], :void

    attach_function :proj_list_angular_units, [], :pointer #PJ_UNITS

    # Contains description of a CRS
    class PROJ_CRS_INFO < FFI::Struct
      fields = [:auth_name, :string, # Authority name
                :code, :string, # Object code
                :name, :string, # Object name
                :type, PJ_TYPE, # Object type
                :deprecated, :int, # Whether the object is deprecated
                :bbox_valid, :int, # Whether bbox values in degrees are valid
                :west_lon_degree, :double, # Western-most longitude of the area of use, in degrees.
                :south_lat_degree, :double, # Southern-most latitude of the area of use, in degrees.
                :east_lon_degree, :double, # Eastern-most longitude of the area of use, in degrees.
                :north_lat_degree, :double,# Northern-most latitude of the area of use, in degrees.
                :area_name, :string, # Name of the area of use
                :projection_method_name, :string] #Name of the projection method for a projected CRS. Might be NULL even for projected CRS in some cases.

                if Api::PROJ_VERSION >= Gem::Version.new('8.1.0')
                  fields += [:celestial_body_name, :string] #Name of the celestial body of the CRS (e.g. "Earth")
                end
      layout(*fields)
    end

    attach_function :proj_crs_info_list_destroy, [:pointer], :void

    # Structure describing optional parameters for proj_get_crs_list
    class PROJ_CRS_LIST_PARAMETERS < FFI::Struct
      fields = [:types, :pointer, # Array of allowed object types. Should be nil if all types are allowed
                :types_count, :size_t, # Size of types. Should be 0 if all types are allowed
                :crs_area_of_use_contains_bbox, :int, # If TRUE and bbox_valid == TRUE, then only CRS whose area of use entirely contains the specified bounding box will be returned. If FALSE and bbox_valid == TRUE, then only CRS whose area of use intersects the specified bounding box will be returned
                :bbox_valid, :int, # To set to TRUE so that west_lon_degree, south_lat_degree, east_lon_degree and north_lat_degree fields are taken into account
                :west_lon_degree, :double, # Western-most longitude of the area of use, in degrees.
                :south_lat_degree, :double, # Southern-most latitude of the area of use, in degrees.
                :east_lon_degree, :double, # Eastern-most longitude of the area of use, in degrees.
                :north_lat_degree, :double,# Northern-most latitude of the area of use, in degrees.
                :allow_deprecated, :int] # Whether deprecated objects are allowed. Default to False

      if Api::PROJ_VERSION >= Gem::Version.new('8.1.0')
        fields += [:celestial_body_name, :string] #Name of the celestial body of the CRS (e.g. "Earth")
      end
      layout(*fields)
    end

    attach_function :proj_get_crs_list_parameters_create, [], :pointer
    attach_function :proj_get_crs_list_parameters_destroy, [:pointer], :void

    # Database functions
    attach_function :proj_context_set_database_path, [:PJ_CONTEXT, :string, :pointer, :pointer], :int
    attach_function :proj_context_get_database_path, [:PJ_CONTEXT], :string
    attach_function :proj_context_get_database_metadata, [:PJ_CONTEXT, :string], :string
    attach_function :proj_get_authorities_from_database, [:PJ_CONTEXT], :PROJ_STRING_LIST
    attach_function :proj_get_codes_from_database, [:PJ_CONTEXT, :string, PJ_TYPE, :int], :PROJ_STRING_LIST
    attach_function :proj_get_crs_info_list_from_database, [:PJ_CONTEXT, :string, PROJ_CRS_LIST_PARAMETERS, :pointer], PROJ_CRS_INFO
    attach_function :proj_uom_get_info_from_database, [:PJ_CONTEXT, :string, :string, :pointer, :pointer, :pointer], :int

    # CRS methods
    attach_function :proj_crs_get_geodetic_crs, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_horizontal_datum, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_sub_crs, [:PJ_CONTEXT, :PJ, :int], :PJ
    attach_function :proj_crs_get_datum, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_coordinate_system, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_cs_get_type, [:PJ_CONTEXT, :PJ], PJ_COORDINATE_SYSTEM_TYPE
    attach_function :proj_cs_get_axis_count, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_cs_get_axis_info, [:PJ_CONTEXT, :PJ, :int, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
    attach_function :proj_crs_get_coordoperation, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_coordoperation_get_accuracy, [:PJ_CONTEXT, :PJ], :double
    attach_function :proj_coordoperation_get_method_info, [:PJ_CONTEXT, :PJ, :pointer, :pointer, :pointer], :int
    attach_function :proj_coordoperation_get_towgs84_values, [:PJ_CONTEXT, :PJ, :pointer, :int, :int], :int
    attach_function :proj_concatoperation_get_step_count, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_concatoperation_get_step, [:PJ_CONTEXT, :PJ, :int], :PJ

    attach_function :proj_get_ellipsoid, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_ellipsoid_get_parameters, [:PJ_CONTEXT, :PJ, :pointer, :pointer, :pointer, :pointer], :int

    attach_function :proj_get_prime_meridian, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_prime_meridian_get_parameters, [:PJ_CONTEXT, :PJ, :pointer, :pointer, :pointer], :int

    # ISO-19111
    attach_function :proj_create_from_wkt, [:PJ_CONTEXT, :string, :pointer, :PROJ_STRING_LIST, :PROJ_STRING_LIST], :PJ
    attach_function :proj_create_from_database, [:PJ_CONTEXT, :string, :string, PJ_CATEGORY, :int, :pointer], :PJ
    attach_function :proj_context_guess_wkt_dialect, [:PJ_CONTEXT, :string], PJ_GUESSED_WKT_DIALECT

    # Undocumented apis
    attach_function :proj_context_use_proj4_init_rules, [:PJ_CONTEXT, :int], :void
    attach_function :proj_context_get_use_proj4_init_rules, [:PJ_CONTEXT, :int], :int
  end
end