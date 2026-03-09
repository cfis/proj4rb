module Proj
  module Api
    attach_variable :PjRelease, :pj_release, :string
    typedef :pointer, :PjArea

    class P5Factors < FFI::Struct
      layout :meridional_scale, :double,
             :parallel_scale, :double,
             :areal_scale, :double,
             :angular_distortion, :double,
             :meridian_parallel_angle, :double,
             :meridian_convergence, :double,
             :tissot_semimajor, :double,
             :tissot_semiminor, :double,
             :dx_dlam, :double,
             :dx_dphi, :double,
             :dy_dlam, :double,
             :dy_dphi, :double
    end

    typedef :pointer, :PJconsts
    callback :pj_list_proj_callback, [:pointer], :pointer

    class PjList < FFI::Struct
      layout :id, :string,
             :proj, :pj_list_proj_callback,
             :descr, :pointer
    end

    class PjEllps < FFI::Struct
      layout :id, :string,
             :major, :string,
             :ell, :string,
             :name, :string
    end

    class PjUnits < FFI::Struct
      layout :id, :string,
             :to_meter, :string,
             :name, :string,
             :factor, :double
    end

    class PjPrimeMeridians < FFI::Struct
      layout :id, :string,
             :defn, :string
    end

    class PjXyzt < FFI::Struct
      layout :x, :double,
             :y, :double,
             :z, :double,
             :t, :double
    end

    class PjUvwt < FFI::Struct
      layout :u, :double,
             :v, :double,
             :w, :double,
             :t, :double
    end

    class PjLpzt < FFI::Struct
      layout :lam, :double,
             :phi, :double,
             :z, :double,
             :t, :double
    end

    class PjOpk < FFI::Struct
      layout :o, :double,
             :p, :double,
             :k, :double
    end

    class PjEnu < FFI::Struct
      layout :e, :double,
             :n, :double,
             :u, :double
    end

    class PjGeod < FFI::Struct
      layout :s, :double,
             :a1, :double,
             :a2, :double
    end

    class PjUv < FFI::Struct
      layout :u, :double,
             :v, :double
    end

    class PjXy < FFI::Struct
      layout :x, :double,
             :y, :double
    end

    class PjLp < FFI::Struct
      layout :lam, :double,
             :phi, :double
    end

    class PjXyz < FFI::Struct
      layout :x, :double,
             :y, :double,
             :z, :double
    end

    class PjUvw < FFI::Struct
      layout :u, :double,
             :v, :double,
             :w, :double
    end

    class PjLpz < FFI::Struct
      layout :lam, :double,
             :phi, :double,
             :z, :double
    end

    class PjCoord < FFI::Union
      layout :v, [:double, 4],
             :xyzt, PjXyzt,
             :uvwt, PjUvwt,
             :lpzt, PjLpzt,
             :geod, PjGeod,
             :opk, PjOpk,
             :enu, PjEnu,
             :xyz, PjXyz,
             :uvw, PjUvw,
             :lpz, PjLpz,
             :xy, PjXy,
             :uv, PjUv,
             :lp, PjLp
    end

    class PjProjInfo < FFI::Struct
      layout :id, :string,
             :description, :string,
             :definition, :string,
             :has_inverse, :int,
             :accuracy, :double
    end

    class PjGridInfo < FFI::Struct
      layout :gridname, [:char, 32],
             :filename, [:char, 260],
             :format, [:char, 8],
             :lowerleft, PjLp,
             :upperright, PjLp,
             :n_lon, :int,
             :n_lat, :int,
             :cs_lon, :double,
             :cs_lat, :double
    end

    class PjInitInfo < FFI::Struct
      layout :name, [:char, 32],
             :filename, [:char, 260],
             :version, [:char, 32],
             :origin, [:char, 32],
             :lastupdate, [:char, 16]
    end

    PjLogLevel = enum(
      :PJ_LOG_NONE, 0,
      :PJ_LOG_ERROR, 1,
      :PJ_LOG_DEBUG, 2,
      :PJ_LOG_TRACE, 3,
      :PJ_LOG_TELL, 4,
      :PJ_LOG_DEBUG_MAJOR, 2,
      :PJ_LOG_DEBUG_MINOR, 3
    )

    callback :pj_log_function, [:pointer, :int, :string], :void
    typedef :pointer, :PjCtx
    attach_function :proj_context_create, :proj_context_create, [], :pointer
    attach_function :proj_context_destroy, :proj_context_destroy, [:pointer], :pointer
    callback :proj_file_finder, [:pointer, :string, :pointer], :pointer
    typedef :pointer, :ProjFileHandle

    ProjOpenAccess = enum(
      :PROJ_OPEN_ACCESS_READ_ONLY, 0,
      :PROJ_OPEN_ACCESS_READ_UPDATE, 1,
      :PROJ_OPEN_ACCESS_CREATE, 2
    )

    callback :proj_file_api_open_cbk_callback, [:pointer, :string, ProjOpenAccess, :pointer], :pointer
    callback :proj_file_api_read_cbk_callback, [:pointer, :pointer, :pointer, :size_t, :pointer], :size_t
    callback :proj_file_api_write_cbk_callback, [:pointer, :pointer, :pointer, :size_t, :pointer], :size_t
    callback :proj_file_api_seek_cbk_callback, [:pointer, :pointer, :long_long, :int, :pointer], :int
    callback :proj_file_api_tell_cbk_callback, [:pointer, :pointer, :pointer], :ulong_long
    callback :proj_file_api_close_cbk_callback, [:pointer, :pointer, :pointer], :void
    callback :proj_file_api_exists_cbk_callback, [:pointer, :string, :pointer], :int
    callback :proj_file_api_mkdir_cbk_callback, [:pointer, :string, :pointer], :int
    callback :proj_file_api_unlink_cbk_callback, [:pointer, :string, :pointer], :int
    callback :proj_file_api_rename_cbk_callback, [:pointer, :string, :string, :pointer], :int

    class ProjFileApi < FFI::Struct
      layout :version, :int,
             :open_cbk, :proj_file_api_open_cbk_callback,
             :read_cbk, :proj_file_api_read_cbk_callback,
             :write_cbk, :proj_file_api_write_cbk_callback,
             :seek_cbk, :proj_file_api_seek_cbk_callback,
             :tell_cbk, :proj_file_api_tell_cbk_callback,
             :close_cbk, :proj_file_api_close_cbk_callback,
             :exists_cbk, :proj_file_api_exists_cbk_callback,
             :mkdir_cbk, :proj_file_api_mkdir_cbk_callback,
             :unlink_cbk, :proj_file_api_unlink_cbk_callback,
             :rename_cbk, :proj_file_api_rename_cbk_callback
    end

    typedef :pointer, :ProjNetworkHandle
    callback :proj_network_open_cbk_type, [:pointer, :string, :ulong_long, :size_t, :pointer, :pointer, :size_t, :pointer, :pointer], :pointer
    callback :proj_network_close_cbk_type, [:pointer, :pointer, :pointer], :void
    callback :proj_network_get_header_value_cbk_type, [:pointer, :pointer, :string, :pointer], :pointer
    callback :proj_network_read_range_type, [:pointer, :pointer, :ulong_long, :size_t, :pointer, :size_t, :pointer, :pointer], :size_t
    attach_function :proj_create, :proj_create, [:pointer, :string], :pointer
    attach_function :proj_create_argv, :proj_create_argv, [:pointer, :int, :pointer], :pointer
    attach_function :proj_create_crs_to_crs, :proj_create_crs_to_crs, [:pointer, :string, :string, :pointer], :pointer
    attach_function :proj_destroy, :proj_destroy, [:pointer], :pointer

    PjDirection = enum(
      :PJ_FWD, 1,
      :PJ_IDENT, 0,
      :PJ_INV, -1
    )

    attach_function :proj_angular_input, :proj_angular_input, [:pointer, PjDirection], :int
    attach_function :proj_angular_output, :proj_angular_output, [:pointer, PjDirection], :int
    attach_function :proj_trans, :proj_trans, [:pointer, PjDirection, PjCoord.by_value], PjCoord.by_value
    attach_function :proj_trans_array, :proj_trans_array, [:pointer, PjDirection, :size_t, :pointer], :int
    attach_function :proj_trans_generic, :proj_trans_generic, [:pointer, PjDirection, :pointer, :size_t, :size_t, :pointer, :size_t, :size_t, :pointer, :size_t, :size_t, :pointer, :size_t, :size_t], :size_t
    attach_function :proj_coord, :proj_coord, [:double, :double, :double, :double], PjCoord.by_value
    attach_function :proj_roundtrip, :proj_roundtrip, [:pointer, PjDirection, :int, PjCoord.by_ref], :double
    attach_function :proj_lp_dist, :proj_lp_dist, [:pointer, PjCoord.by_value, PjCoord.by_value], :double
    attach_function :proj_lpz_dist, :proj_lpz_dist, [:pointer, PjCoord.by_value, PjCoord.by_value], :double
    attach_function :proj_xy_dist, :proj_xy_dist, [PjCoord.by_value, PjCoord.by_value], :double
    attach_function :proj_xyz_dist, :proj_xyz_dist, [PjCoord.by_value, PjCoord.by_value], :double
    attach_function :proj_geod, :proj_geod, [:pointer, PjCoord.by_value, PjCoord.by_value], PjCoord.by_value
    attach_function :proj_context_errno, :proj_context_errno, [:pointer], :int
    attach_function :proj_errno, :proj_errno, [:pointer], :int
    attach_function :proj_errno_set, :proj_errno_set, [:pointer, :int], :int
    attach_function :proj_errno_reset, :proj_errno_reset, [:pointer], :int
    attach_function :proj_errno_restore, :proj_errno_restore, [:pointer, :int], :int
    attach_function :proj_factors, :proj_factors, [:pointer, PjCoord.by_value], P5Factors.by_value
    attach_function :proj_pj_info, :proj_pj_info, [:pointer], PjProjInfo.by_value
    attach_function :proj_grid_info, :proj_grid_info, [:string], PjGridInfo.by_value
    attach_function :proj_init_info, :proj_init_info, [:string], PjInitInfo.by_value
    attach_function :proj_list_operations, :proj_list_operations, [], :pointer
    attach_function :proj_list_ellps, :proj_list_ellps, [], :pointer
    attach_function :proj_list_prime_meridians, :proj_list_prime_meridians, [], :pointer
    attach_function :proj_torad, :proj_torad, [:double], :double
    attach_function :proj_todeg, :proj_todeg, [:double], :double
    attach_function :proj_dmstor, :proj_dmstor, [:string, :pointer], :double
    typedef :pointer, :proj_string_list

    PjGuessedWktDialect = enum(
      :PJ_GUESSED_WKT2_2019, 0,
      :PJ_GUESSED_WKT2_2018, 0,
      :PJ_GUESSED_WKT2_2015, 1,
      :PJ_GUESSED_WKT1_GDAL, 2,
      :PJ_GUESSED_WKT1_ESRI, 3,
      :PJ_GUESSED_NOT_WKT, 4
    )

    PjCategory = enum(
      :PJ_CATEGORY_ELLIPSOID, 0,
      :PJ_CATEGORY_PRIME_MERIDIAN, 1,
      :PJ_CATEGORY_DATUM, 2,
      :PJ_CATEGORY_CRS, 3,
      :PJ_CATEGORY_COORDINATE_OPERATION, 4,
      :PJ_CATEGORY_DATUM_ENSEMBLE, 5
    )

    PjType = enum(
      :PJ_TYPE_UNKNOWN, 0,
      :PJ_TYPE_ELLIPSOID, 1,
      :PJ_TYPE_PRIME_MERIDIAN, 2,
      :PJ_TYPE_GEODETIC_REFERENCE_FRAME, 3,
      :PJ_TYPE_DYNAMIC_GEODETIC_REFERENCE_FRAME, 4,
      :PJ_TYPE_VERTICAL_REFERENCE_FRAME, 5,
      :PJ_TYPE_DYNAMIC_VERTICAL_REFERENCE_FRAME, 6,
      :PJ_TYPE_DATUM_ENSEMBLE, 7,
      :PJ_TYPE_CRS, 8,
      :PJ_TYPE_GEODETIC_CRS, 9,
      :PJ_TYPE_GEOCENTRIC_CRS, 10,
      :PJ_TYPE_GEOGRAPHIC_CRS, 11,
      :PJ_TYPE_GEOGRAPHIC_2D_CRS, 12,
      :PJ_TYPE_GEOGRAPHIC_3D_CRS, 13,
      :PJ_TYPE_VERTICAL_CRS, 14,
      :PJ_TYPE_PROJECTED_CRS, 15,
      :PJ_TYPE_COMPOUND_CRS, 16,
      :PJ_TYPE_TEMPORAL_CRS, 17,
      :PJ_TYPE_ENGINEERING_CRS, 18,
      :PJ_TYPE_BOUND_CRS, 19,
      :PJ_TYPE_OTHER_CRS, 20,
      :PJ_TYPE_CONVERSION, 21,
      :PJ_TYPE_TRANSFORMATION, 22,
      :PJ_TYPE_CONCATENATED_OPERATION, 23,
      :PJ_TYPE_OTHER_COORDINATE_OPERATION, 24,
      :PJ_TYPE_TEMPORAL_DATUM, 25,
      :PJ_TYPE_ENGINEERING_DATUM, 26,
      :PJ_TYPE_PARAMETRIC_DATUM, 27,
      :PJ_TYPE_DERIVED_PROJECTED_CRS, 28,
      :PJ_TYPE_COORDINATE_METADATA, 29
    )

    PjComparisonCriterion = enum(
      :PJ_COMP_STRICT, 0,
      :PJ_COMP_EQUIVALENT, 1,
      :PJ_COMP_EQUIVALENT_EXCEPT_AXIS_ORDER_GEOGCRS, 2
    )

    PjWktType = enum(
      :PJ_WKT2_2015, 0,
      :PJ_WKT2_2015_SIMPLIFIED, 1,
      :PJ_WKT2_2019, 2,
      :PJ_WKT2_2018, 2,
      :PJ_WKT2_2019_SIMPLIFIED, 3,
      :PJ_WKT2_2018_SIMPLIFIED, 3,
      :PJ_WKT1_GDAL, 4,
      :PJ_WKT1_ESRI, 5
    )

    ProjCrsExtentUse = enum(
      :PJ_CRS_EXTENT_NONE, 0,
      :PJ_CRS_EXTENT_BOTH, 1,
      :PJ_CRS_EXTENT_INTERSECTION, 2,
      :PJ_CRS_EXTENT_SMALLEST, 3
    )

    ProjGridAvailabilityUse = enum(
      :PROJ_GRID_AVAILABILITY_USED_FOR_SORTING, 0,
      :PROJ_GRID_AVAILABILITY_DISCARD_OPERATION_IF_MISSING_GRID, 1,
      :PROJ_GRID_AVAILABILITY_IGNORED, 2,
      :PROJ_GRID_AVAILABILITY_KNOWN_AVAILABLE, 3
    )

    PjProjStringType = enum(
      :PJ_PROJ_5, 0,
      :PJ_PROJ_4, 1
    )

    ProjSpatialCriterion = enum(
      :PROJ_SPATIAL_CRITERION_STRICT_CONTAINMENT, 0,
      :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION, 1
    )

    ProjIntermediateCrsUse = enum(
      :PROJ_INTERMEDIATE_CRS_USE_ALWAYS, 0,
      :PROJ_INTERMEDIATE_CRS_USE_IF_NO_DIRECT_TRANSFORMATION, 1,
      :PROJ_INTERMEDIATE_CRS_USE_NEVER, 2
    )

    PjCoordinateSystemType = enum(
      :PJ_CS_TYPE_UNKNOWN, 0,
      :PJ_CS_TYPE_CARTESIAN, 1,
      :PJ_CS_TYPE_ELLIPSOIDAL, 2,
      :PJ_CS_TYPE_VERTICAL, 3,
      :PJ_CS_TYPE_SPHERICAL, 4,
      :PJ_CS_TYPE_ORDINAL, 5,
      :PJ_CS_TYPE_PARAMETRIC, 6,
      :PJ_CS_TYPE_DATETIMETEMPORAL, 7,
      :PJ_CS_TYPE_TEMPORALCOUNT, 8,
      :PJ_CS_TYPE_TEMPORALMEASURE, 9
    )

    class ProjCrsInfo < FFI::Struct
      layout :auth_name, :pointer,
             :code, :pointer,
             :name, :pointer,
             :type, PjType,
             :deprecated, :int,
             :bbox_valid, :int,
             :west_lon_degree, :double,
             :south_lat_degree, :double,
             :east_lon_degree, :double,
             :north_lat_degree, :double,
             :area_name, :pointer,
             :projection_method_name, :pointer,
             :celestial_body_name, :pointer
    end

    class ProjCrsListParameters < FFI::Struct
      layout :types, :pointer,
             :types_count, :size_t,
             :crs_area_of_use_contains_bbox, :int,
             :bbox_valid, :int,
             :west_lon_degree, :double,
             :south_lat_degree, :double,
             :east_lon_degree, :double,
             :north_lat_degree, :double,
             :allow_deprecated, :int,
             :celestial_body_name, :string
    end

    class ProjUnitInfo < FFI::Struct
      layout :auth_name, :pointer,
             :code, :pointer,
             :name, :pointer,
             :category, :pointer,
             :conv_factor, :double,
             :proj_short_name, :pointer,
             :deprecated, :int
    end

    class ProjCelestialBodyInfo < FFI::Struct
      layout :auth_name, :pointer,
             :name, :pointer
    end

    typedef :pointer, :PjObjList
    typedef :pointer, :PjInsertSession
    typedef :pointer, :PjOperationFactoryContext

    PjUnitType = enum(
      :PJ_UT_ANGULAR, 0,
      :PJ_UT_LINEAR, 1,
      :PJ_UT_SCALE, 2,
      :PJ_UT_TIME, 3,
      :PJ_UT_PARAMETRIC, 4
    )

    class PjAxisDescription < FFI::Struct
      layout :name, :pointer,
             :abbreviation, :pointer,
             :direction, :pointer,
             :unit_name, :pointer,
             :unit_conv_factor, :double,
             :unit_type, PjUnitType
    end

    PjCartesianCs2dType = enum(
      :PJ_CART2D_EASTING_NORTHING, 0,
      :PJ_CART2D_NORTHING_EASTING, 1,
      :PJ_CART2D_NORTH_POLE_EASTING_SOUTH_NORTHING_SOUTH, 2,
      :PJ_CART2D_SOUTH_POLE_EASTING_NORTH_NORTHING_NORTH, 3,
      :PJ_CART2D_WESTING_SOUTHING, 4
    )

    PjEllipsoidalCs2dType = enum(
      :PJ_ELLPS2D_LONGITUDE_LATITUDE, 0,
      :PJ_ELLPS2D_LATITUDE_LONGITUDE, 1
    )

    PjEllipsoidalCs3dType = enum(
      :PJ_ELLPS3D_LONGITUDE_LATITUDE_HEIGHT, 0,
      :PJ_ELLPS3D_LATITUDE_LONGITUDE_HEIGHT, 1
    )

    class PjParamDescription < FFI::Struct
      layout :name, :string,
             :auth_name, :string,
             :code, :string,
             :value, :double,
             :unit_name, :string,
             :unit_conv_factor, :double,
             :unit_type, PjUnitType
    end

    if proj_version >= 50100
      attach_function :proj_errno_string, :proj_errno_string, [:int], :string
      attach_function :proj_log_level, :proj_log_level, [:pointer, PjLogLevel], PjLogLevel
      attach_function :proj_log_func, :proj_log_func, [:pointer, :pointer, :pj_log_function], :void
    end
    if proj_version >= 60000
      attach_function :proj_context_set_file_finder, :proj_context_set_file_finder, [:pointer, :proj_file_finder, :pointer], :void
      attach_function :proj_context_set_search_paths, :proj_context_set_search_paths, [:pointer, :int, :pointer], :void
      attach_function :proj_context_use_proj4_init_rules, :proj_context_use_proj4_init_rules, [:pointer, :int], :void
      attach_function :proj_context_get_use_proj4_init_rules, :proj_context_get_use_proj4_init_rules, [:pointer, :int], :int
      attach_function :proj_assign_context, :proj_assign_context, [:pointer, :pointer], :void
      attach_function :proj_area_create, :proj_area_create, [], :pointer
      attach_function :proj_area_set_bbox, :proj_area_set_bbox, [:pointer, :double, :double, :double, :double], :void
      attach_function :proj_area_destroy, :proj_area_destroy, [:pointer], :void
      attach_function :proj_string_list_destroy, :proj_string_list_destroy, [:pointer], :void
      attach_function :proj_context_set_database_path, :proj_context_set_database_path, [:pointer, :string, :pointer, :pointer], :int
      attach_function :proj_context_get_database_path, :proj_context_get_database_path, [:pointer], :string
      attach_function :proj_context_get_database_metadata, :proj_context_get_database_metadata, [:pointer, :string], :string
      attach_function :proj_context_guess_wkt_dialect, :proj_context_guess_wkt_dialect, [:pointer, :string], PjGuessedWktDialect
      attach_function :proj_create_from_wkt, :proj_create_from_wkt, [:pointer, :string, :pointer, :pointer, :pointer], :pointer
      attach_function :proj_create_from_database, :proj_create_from_database, [:pointer, :string, :string, PjCategory, :int, :pointer], :pointer
      attach_function :proj_uom_get_info_from_database, :proj_uom_get_info_from_database, [:pointer, :string, :string, :pointer, :pointer, :pointer], :int
      attach_function :proj_clone, :proj_clone, [:pointer, :pointer], :pointer
      attach_function :proj_create_from_name, :proj_create_from_name, [:pointer, :string, :string, :pointer, :size_t, :int, :size_t, :pointer], :pointer
      attach_function :proj_get_type, :proj_get_type, [:pointer], PjType
      attach_function :proj_is_deprecated, :proj_is_deprecated, [:pointer], :int
      attach_function :proj_get_non_deprecated, :proj_get_non_deprecated, [:pointer, :pointer], :pointer
      attach_function :proj_is_equivalent_to, :proj_is_equivalent_to, [:pointer, :pointer, PjComparisonCriterion], :int
      attach_function :proj_is_crs, :proj_is_crs, [:pointer], :bool
      attach_function :proj_get_name, :proj_get_name, [:pointer], :string
      attach_function :proj_get_id_auth_name, :proj_get_id_auth_name, [:pointer, :int], :string
      attach_function :proj_get_id_code, :proj_get_id_code, [:pointer, :int], :string
      attach_function :proj_get_area_of_use, :proj_get_area_of_use, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
      attach_function :proj_as_wkt, :proj_as_wkt, [:pointer, :pointer, PjWktType, :pointer], :string
      attach_function :proj_as_proj_string, :proj_as_proj_string, [:pointer, :pointer, PjProjStringType, :pointer], :string
      attach_function :proj_get_source_crs, :proj_get_source_crs, [:pointer, :pointer], :pointer
      attach_function :proj_get_target_crs, :proj_get_target_crs, [:pointer, :pointer], :pointer
      attach_function :proj_identify, :proj_identify, [:pointer, :pointer, :string, :pointer, :pointer], :pointer
      attach_function :proj_int_list_destroy, :proj_int_list_destroy, [:pointer], :void
      attach_function :proj_get_authorities_from_database, :proj_get_authorities_from_database, [:pointer], :pointer
      attach_function :proj_get_codes_from_database, :proj_get_codes_from_database, [:pointer, :string, PjType, :int], :pointer
      attach_function :proj_get_crs_list_parameters_create, :proj_get_crs_list_parameters_create, [], ProjCrsListParameters.by_ref
      attach_function :proj_get_crs_list_parameters_destroy, :proj_get_crs_list_parameters_destroy, [ProjCrsListParameters.by_ref], :void
      attach_function :proj_get_crs_info_list_from_database, :proj_get_crs_info_list_from_database, [:pointer, :string, ProjCrsListParameters.by_ref, :pointer], :pointer
      attach_function :proj_crs_info_list_destroy, :proj_crs_info_list_destroy, [:pointer], :void
      attach_function :proj_create_operation_factory_context, :proj_create_operation_factory_context, [:pointer, :string], :pointer
      attach_function :proj_operation_factory_context_destroy, :proj_operation_factory_context_destroy, [:pointer], :void
      attach_function :proj_operation_factory_context_set_desired_accuracy, :proj_operation_factory_context_set_desired_accuracy, [:pointer, :pointer, :double], :void
      attach_function :proj_operation_factory_context_set_area_of_interest, :proj_operation_factory_context_set_area_of_interest, [:pointer, :pointer, :double, :double, :double, :double], :void
      attach_function :proj_operation_factory_context_set_crs_extent_use, :proj_operation_factory_context_set_crs_extent_use, [:pointer, :pointer, ProjCrsExtentUse], :void
      attach_function :proj_operation_factory_context_set_spatial_criterion, :proj_operation_factory_context_set_spatial_criterion, [:pointer, :pointer, ProjSpatialCriterion], :void
      attach_function :proj_operation_factory_context_set_grid_availability_use, :proj_operation_factory_context_set_grid_availability_use, [:pointer, :pointer, ProjGridAvailabilityUse], :void
      attach_function :proj_operation_factory_context_set_use_proj_alternative_grid_names, :proj_operation_factory_context_set_use_proj_alternative_grid_names, [:pointer, :pointer, :int], :void
      attach_function :proj_operation_factory_context_set_allow_use_intermediate_crs, :proj_operation_factory_context_set_allow_use_intermediate_crs, [:pointer, :pointer, ProjIntermediateCrsUse], :void
      attach_function :proj_operation_factory_context_set_allowed_intermediate_crs, :proj_operation_factory_context_set_allowed_intermediate_crs, [:pointer, :pointer, :pointer], :void
      attach_function :proj_create_operations, :proj_create_operations, [:pointer, :pointer, :pointer, :pointer], :pointer
      attach_function :proj_list_get_count, :proj_list_get_count, [:pointer], :int
      attach_function :proj_list_get, :proj_list_get, [:pointer, :pointer, :int], :pointer
      attach_function :proj_list_destroy, :proj_list_destroy, [:pointer], :void
      attach_function :proj_crs_get_geodetic_crs, :proj_crs_get_geodetic_crs, [:pointer, :pointer], :pointer
      attach_function :proj_crs_get_horizontal_datum, :proj_crs_get_horizontal_datum, [:pointer, :pointer], :pointer
      attach_function :proj_crs_get_sub_crs, :proj_crs_get_sub_crs, [:pointer, :pointer, :int], :pointer
      attach_function :proj_crs_get_datum, :proj_crs_get_datum, [:pointer, :pointer], :pointer
      attach_function :proj_crs_get_coordinate_system, :proj_crs_get_coordinate_system, [:pointer, :pointer], :pointer
      attach_function :proj_cs_get_type, :proj_cs_get_type, [:pointer, :pointer], PjCoordinateSystemType
      attach_function :proj_cs_get_axis_count, :proj_cs_get_axis_count, [:pointer, :pointer], :int
      attach_function :proj_cs_get_axis_info, :proj_cs_get_axis_info, [:pointer, :pointer, :int, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
      attach_function :proj_get_ellipsoid, :proj_get_ellipsoid, [:pointer, :pointer], :pointer
      attach_function :proj_ellipsoid_get_parameters, :proj_ellipsoid_get_parameters, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
      attach_function :proj_get_prime_meridian, :proj_get_prime_meridian, [:pointer, :pointer], :pointer
      attach_function :proj_prime_meridian_get_parameters, :proj_prime_meridian_get_parameters, [:pointer, :pointer, :pointer, :pointer, :pointer], :int
      attach_function :proj_crs_get_coordoperation, :proj_crs_get_coordoperation, [:pointer, :pointer], :pointer
      attach_function :proj_coordoperation_get_method_info, :proj_coordoperation_get_method_info, [:pointer, :pointer, :pointer, :pointer, :pointer], :int
      attach_function :proj_coordoperation_is_instantiable, :proj_coordoperation_is_instantiable, [:pointer, :pointer], :int
      attach_function :proj_coordoperation_has_ballpark_transformation, :proj_coordoperation_has_ballpark_transformation, [:pointer, :pointer], :int
      attach_function :proj_coordoperation_get_param_count, :proj_coordoperation_get_param_count, [:pointer, :pointer], :int
      attach_function :proj_coordoperation_get_param_index, :proj_coordoperation_get_param_index, [:pointer, :pointer, :string], :int
      attach_function :proj_coordoperation_get_param, :proj_coordoperation_get_param, [:pointer, :pointer, :int, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
      attach_function :proj_coordoperation_get_grid_used_count, :proj_coordoperation_get_grid_used_count, [:pointer, :pointer], :int
      attach_function :proj_coordoperation_get_grid_used, :proj_coordoperation_get_grid_used, [:pointer, :pointer, :int, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
      attach_function :proj_coordoperation_get_accuracy, :proj_coordoperation_get_accuracy, [:pointer, :pointer], :double
      attach_function :proj_coordoperation_get_towgs84_values, :proj_coordoperation_get_towgs84_values, [:pointer, :pointer, :pointer, :int, :int], :int
      attach_function :proj_create_cs, :proj_create_cs, [:pointer, PjCoordinateSystemType, :int, :pointer], :pointer
      attach_function :proj_create_cartesian_2d_cs, :proj_create_cartesian_2D_cs, [:pointer, PjCartesianCs2dType, :string, :double], :pointer
      attach_function :proj_create_ellipsoidal_2d_cs, :proj_create_ellipsoidal_2D_cs, [:pointer, PjEllipsoidalCs2dType, :string, :double], :pointer
      attach_function :proj_query_geodetic_crs_from_datum, :proj_query_geodetic_crs_from_datum, [:pointer, :string, :string, :string, :string], :pointer
      attach_function :proj_create_geographic_crs, :proj_create_geographic_crs, [:pointer, :string, :string, :string, :double, :double, :string, :double, :string, :double, :pointer], :pointer
      attach_function :proj_create_geographic_crs_from_datum, :proj_create_geographic_crs_from_datum, [:pointer, :string, :pointer, :pointer], :pointer
      attach_function :proj_create_geocentric_crs, :proj_create_geocentric_crs, [:pointer, :string, :string, :string, :double, :double, :string, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_geocentric_crs_from_datum, :proj_create_geocentric_crs_from_datum, [:pointer, :string, :pointer, :string, :double], :pointer
      attach_function :proj_alter_name, :proj_alter_name, [:pointer, :pointer, :string], :pointer
      attach_function :proj_alter_id, :proj_alter_id, [:pointer, :pointer, :string, :string], :pointer
      attach_function :proj_crs_alter_geodetic_crs, :proj_crs_alter_geodetic_crs, [:pointer, :pointer, :pointer], :pointer
      attach_function :proj_crs_alter_cs_angular_unit, :proj_crs_alter_cs_angular_unit, [:pointer, :pointer, :string, :double, :string, :string], :pointer
      attach_function :proj_crs_alter_cs_linear_unit, :proj_crs_alter_cs_linear_unit, [:pointer, :pointer, :string, :double, :string, :string], :pointer
      attach_function :proj_crs_alter_parameters_linear_unit, :proj_crs_alter_parameters_linear_unit, [:pointer, :pointer, :string, :double, :string, :string, :int], :pointer
      attach_function :proj_create_engineering_crs, :proj_create_engineering_crs, [:pointer, :string], :pointer
      attach_function :proj_create_vertical_crs, :proj_create_vertical_crs, [:pointer, :string, :string, :string, :double], :pointer
      attach_function :proj_create_compound_crs, :proj_create_compound_crs, [:pointer, :string, :pointer, :pointer], :pointer
      attach_function :proj_create_conversion, :proj_create_conversion, [:pointer, :string, :string, :string, :string, :string, :string, :int, :pointer], :pointer
      attach_function :proj_create_transformation, :proj_create_transformation, [:pointer, :string, :string, :string, :pointer, :pointer, :pointer, :string, :string, :string, :int, :pointer, :double], :pointer
      attach_function :proj_convert_conversion_to_other_method, :proj_convert_conversion_to_other_method, [:pointer, :pointer, :int, :string], :pointer
      attach_function :proj_create_projected_crs, :proj_create_projected_crs, [:pointer, :string, :pointer, :pointer, :pointer], :pointer
      attach_function :proj_crs_create_bound_crs, :proj_crs_create_bound_crs, [:pointer, :pointer, :pointer, :pointer], :pointer
      attach_function :proj_crs_create_bound_crs_to_wgs84, :proj_crs_create_bound_crs_to_WGS84, [:pointer, :pointer, :pointer], :pointer
      attach_function :proj_create_conversion_utm, :proj_create_conversion_utm, [:pointer, :int, :int], :pointer
      attach_function :proj_create_conversion_transverse_mercator, :proj_create_conversion_transverse_mercator, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_gauss_schreiber_transverse_mercator, :proj_create_conversion_gauss_schreiber_transverse_mercator, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_transverse_mercator_south_oriented, :proj_create_conversion_transverse_mercator_south_oriented, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_two_point_equidistant, :proj_create_conversion_two_point_equidistant, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_tunisia_mapping_grid, :proj_create_conversion_tunisia_mapping_grid, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_albers_equal_area, :proj_create_conversion_albers_equal_area, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_lambert_conic_conformal_1sp, :proj_create_conversion_lambert_conic_conformal_1sp, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_lambert_conic_conformal_2sp, :proj_create_conversion_lambert_conic_conformal_2sp, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_lambert_conic_conformal_2sp_michigan, :proj_create_conversion_lambert_conic_conformal_2sp_michigan, [:pointer, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_lambert_conic_conformal_2sp_belgium, :proj_create_conversion_lambert_conic_conformal_2sp_belgium, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_azimuthal_equidistant, :proj_create_conversion_azimuthal_equidistant, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_guam_projection, :proj_create_conversion_guam_projection, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_bonne, :proj_create_conversion_bonne, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_lambert_cylindrical_equal_area_spherical, :proj_create_conversion_lambert_cylindrical_equal_area_spherical, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_lambert_cylindrical_equal_area, :proj_create_conversion_lambert_cylindrical_equal_area, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_cassini_soldner, :proj_create_conversion_cassini_soldner, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_equidistant_conic, :proj_create_conversion_equidistant_conic, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_eckert_i, :proj_create_conversion_eckert_i, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_eckert_ii, :proj_create_conversion_eckert_ii, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_eckert_iii, :proj_create_conversion_eckert_iii, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_eckert_iv, :proj_create_conversion_eckert_iv, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_eckert_v, :proj_create_conversion_eckert_v, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_eckert_vi, :proj_create_conversion_eckert_vi, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_equidistant_cylindrical, :proj_create_conversion_equidistant_cylindrical, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_equidistant_cylindrical_spherical, :proj_create_conversion_equidistant_cylindrical_spherical, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_gall, :proj_create_conversion_gall, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_goode_homolosine, :proj_create_conversion_goode_homolosine, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_interrupted_goode_homolosine, :proj_create_conversion_interrupted_goode_homolosine, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_geostationary_satellite_sweep_x, :proj_create_conversion_geostationary_satellite_sweep_x, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_geostationary_satellite_sweep_y, :proj_create_conversion_geostationary_satellite_sweep_y, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_gnomonic, :proj_create_conversion_gnomonic, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_hotine_oblique_mercator_variant_a, :proj_create_conversion_hotine_oblique_mercator_variant_a, [:pointer, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_hotine_oblique_mercator_variant_b, :proj_create_conversion_hotine_oblique_mercator_variant_b, [:pointer, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_hotine_oblique_mercator_two_point_natural_origin, :proj_create_conversion_hotine_oblique_mercator_two_point_natural_origin, [:pointer, :double, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_laborde_oblique_mercator, :proj_create_conversion_laborde_oblique_mercator, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_international_map_world_polyconic, :proj_create_conversion_international_map_world_polyconic, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_krovak_north_oriented, :proj_create_conversion_krovak_north_oriented, [:pointer, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_krovak, :proj_create_conversion_krovak, [:pointer, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_lambert_azimuthal_equal_area, :proj_create_conversion_lambert_azimuthal_equal_area, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_miller_cylindrical, :proj_create_conversion_miller_cylindrical, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_mercator_variant_a, :proj_create_conversion_mercator_variant_a, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_mercator_variant_b, :proj_create_conversion_mercator_variant_b, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_popular_visualisation_pseudo_mercator, :proj_create_conversion_popular_visualisation_pseudo_mercator, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_mollweide, :proj_create_conversion_mollweide, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_new_zealand_mapping_grid, :proj_create_conversion_new_zealand_mapping_grid, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_oblique_stereographic, :proj_create_conversion_oblique_stereographic, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_orthographic, :proj_create_conversion_orthographic, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_american_polyconic, :proj_create_conversion_american_polyconic, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_polar_stereographic_variant_a, :proj_create_conversion_polar_stereographic_variant_a, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_polar_stereographic_variant_b, :proj_create_conversion_polar_stereographic_variant_b, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_robinson, :proj_create_conversion_robinson, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_sinusoidal, :proj_create_conversion_sinusoidal, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_stereographic, :proj_create_conversion_stereographic, [:pointer, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_van_der_grinten, :proj_create_conversion_van_der_grinten, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_wagner_i, :proj_create_conversion_wagner_i, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_wagner_ii, :proj_create_conversion_wagner_ii, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_wagner_iii, :proj_create_conversion_wagner_iii, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_wagner_iv, :proj_create_conversion_wagner_iv, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_wagner_v, :proj_create_conversion_wagner_v, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_wagner_vi, :proj_create_conversion_wagner_vi, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_wagner_vii, :proj_create_conversion_wagner_vii, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_quadrilateralized_spherical_cube, :proj_create_conversion_quadrilateralized_spherical_cube, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_spherical_cross_track_height, :proj_create_conversion_spherical_cross_track_height, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_equal_earth, :proj_create_conversion_equal_earth, [:pointer, :double, :double, :double, :string, :double, :string, :double], :pointer
    end
    if proj_version >= 60100
      attach_function :proj_normalize_for_visualization, :proj_normalize_for_visualization, [:pointer, :pointer], :pointer
    end
    if proj_version >= 60200
      attach_function :proj_create_crs_to_crs_from_pj, :proj_create_crs_to_crs_from_pj, [:pointer, :pointer, :pointer, :pointer, :pointer], :pointer
      attach_function :proj_cleanup, :proj_cleanup, [], :void
      attach_function :proj_context_set_autoclose_database, :proj_context_set_autoclose_database, [:pointer, :int], :void
      attach_function :proj_grid_get_info_from_database, :proj_grid_get_info_from_database, [:pointer, :string, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
      attach_function :proj_get_remarks, :proj_get_remarks, [:pointer], :string
      attach_function :proj_get_scope, :proj_get_scope, [:pointer], :string
      attach_function :proj_as_projjson, :proj_as_projjson, [:pointer, :pointer, :pointer], :string
      attach_function :proj_operation_factory_context_set_discard_superseded, :proj_operation_factory_context_set_discard_superseded, [:pointer, :pointer, :int], :void
      attach_function :proj_concatoperation_get_step_count, :proj_concatoperation_get_step_count, [:pointer, :pointer], :int
      attach_function :proj_concatoperation_get_step, :proj_concatoperation_get_step, [:pointer, :pointer, :int], :pointer
    end
    if proj_version >= 60300
      attach_function :proj_is_equivalent_to_with_ctx, :proj_is_equivalent_to_with_ctx, [:pointer, :pointer, :pointer, PjComparisonCriterion], :int
      attach_function :proj_coordoperation_create_inverse, :proj_coordoperation_create_inverse, [:pointer, :pointer], :pointer
      attach_function :proj_create_ellipsoidal_3d_cs, :proj_create_ellipsoidal_3D_cs, [:pointer, PjEllipsoidalCs3dType, :string, :double, :string, :double], :pointer
      attach_function :proj_create_derived_geographic_crs, :proj_create_derived_geographic_crs, [:pointer, :string, :pointer, :pointer, :pointer], :pointer
      attach_function :proj_is_derived_crs, :proj_is_derived_crs, [:pointer, :pointer], :int
      attach_function :proj_crs_promote_to_3d, :proj_crs_promote_to_3D, [:pointer, :string, :pointer], :pointer
      attach_function :proj_crs_create_projected_3d_crs_from_2d, :proj_crs_create_projected_3D_crs_from_2D, [:pointer, :string, :pointer, :pointer], :pointer
      attach_function :proj_crs_demote_to_2d, :proj_crs_demote_to_2D, [:pointer, :string, :pointer], :pointer
      attach_function :proj_create_vertical_crs_ex, :proj_create_vertical_crs_ex, [:pointer, :string, :string, :string, :string, :string, :double, :string, :string, :string, :pointer, :pointer], :pointer
      attach_function :proj_crs_create_bound_vertical_crs, :proj_crs_create_bound_vertical_crs, [:pointer, :pointer, :pointer, :string], :pointer
      attach_function :proj_create_conversion_vertical_perspective, :proj_create_conversion_vertical_perspective, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
      attach_function :proj_create_conversion_pole_rotation_grib_convention, :proj_create_conversion_pole_rotation_grib_convention, [:pointer, :double, :double, :double, :string, :double], :pointer
    end
    if proj_version >= 70000
      attach_function :proj_context_set_fileapi, :proj_context_set_fileapi, [:pointer, ProjFileApi.by_ref, :pointer], :int
      attach_function :proj_context_set_sqlite3_vfs_name, :proj_context_set_sqlite3_vfs_name, [:pointer, :string], :void
      attach_function :proj_context_set_network_callbacks, :proj_context_set_network_callbacks, [:pointer, :proj_network_open_cbk_type, :proj_network_close_cbk_type, :proj_network_get_header_value_cbk_type, :proj_network_read_range_type, :pointer], :int
      attach_function :proj_context_set_enable_network, :proj_context_set_enable_network, [:pointer, :int], :int
      attach_function :proj_context_is_network_enabled, :proj_context_is_network_enabled, [:pointer], :int
      attach_function :proj_context_set_url_endpoint, :proj_context_set_url_endpoint, [:pointer, :string], :void
      attach_function :proj_grid_cache_set_enable, :proj_grid_cache_set_enable, [:pointer, :int], :void
      attach_function :proj_grid_cache_set_filename, :proj_grid_cache_set_filename, [:pointer, :string], :void
      attach_function :proj_grid_cache_set_max_size, :proj_grid_cache_set_max_size, [:pointer, :int], :void
      attach_function :proj_grid_cache_set_ttl, :proj_grid_cache_set_ttl, [:pointer, :int], :void
      attach_function :proj_grid_cache_clear, :proj_grid_cache_clear, [:pointer], :void
      attach_function :proj_is_download_needed, :proj_is_download_needed, [:pointer, :string, :int], :int
      callback :proj_download_file_progress_cbk_callback, [:pointer, :double, :pointer], :int
      attach_function :proj_download_file, :proj_download_file, [:pointer, :string, :int, :proj_download_file_progress_cbk_callback, :pointer], :int
    end
    if proj_version >= 70100
      attach_function :proj_context_get_url_endpoint, :proj_context_get_url_endpoint, [:pointer], :string
      attach_function :proj_context_get_user_writable_directory, :proj_context_get_user_writable_directory, [:pointer, :int], :string
      attach_function :proj_degree_input, :proj_degree_input, [:pointer, PjDirection], :int
      attach_function :proj_degree_output, :proj_degree_output, [:pointer, PjDirection], :int
      attach_function :proj_get_units_from_database, :proj_get_units_from_database, [:pointer, :string, :string, :int, :pointer], :pointer
      attach_function :proj_unit_list_destroy, :proj_unit_list_destroy, [:pointer], :void
      attach_function :proj_operation_factory_context_set_allow_ballpark_transformations, :proj_operation_factory_context_set_allow_ballpark_transformations, [:pointer, :pointer, :int], :void
      attach_function :proj_get_suggested_operation, :proj_get_suggested_operation, [:pointer, :pointer, PjDirection, PjCoord.by_value], :int
    end
    if proj_version >= 70200
      attach_function :proj_context_clone, :proj_context_clone, [:pointer], :pointer
      attach_function :proj_context_set_ca_bundle_path, :proj_context_set_ca_bundle_path, [:pointer, :string], :void
      attach_function :proj_crs_get_datum_ensemble, :proj_crs_get_datum_ensemble, [:pointer, :pointer], :pointer
      attach_function :proj_crs_get_datum_forced, :proj_crs_get_datum_forced, [:pointer, :pointer], :pointer
      attach_function :proj_datum_ensemble_get_member_count, :proj_datum_ensemble_get_member_count, [:pointer, :pointer], :int
      attach_function :proj_datum_ensemble_get_accuracy, :proj_datum_ensemble_get_accuracy, [:pointer, :pointer], :double
      attach_function :proj_datum_ensemble_get_member, :proj_datum_ensemble_get_member, [:pointer, :pointer, :int], :pointer
      attach_function :proj_dynamic_datum_get_frame_reference_epoch, :proj_dynamic_datum_get_frame_reference_epoch, [:pointer, :pointer], :double
    end
    if proj_version >= 80000
      attach_function :proj_context_errno_string, :proj_context_errno_string, [:pointer, :int], :string
      attach_function :proj_crs_is_derived, :proj_crs_is_derived, [:pointer, :pointer], :int
    end
    if proj_version >= 80100
      attach_function :proj_context_get_database_structure, :proj_context_get_database_structure, [:pointer, :pointer], :pointer
      attach_function :proj_get_geoid_models_from_database, :proj_get_geoid_models_from_database, [:pointer, :string, :string, :pointer], :pointer
      attach_function :proj_get_celestial_body_list_from_database, :proj_get_celestial_body_list_from_database, [:pointer, :string, :pointer], :pointer
      attach_function :proj_celestial_body_list_destroy, :proj_celestial_body_list_destroy, [:pointer], :void
      attach_function :proj_insert_object_session_create, :proj_insert_object_session_create, [:pointer], :pointer
      attach_function :proj_insert_object_session_destroy, :proj_insert_object_session_destroy, [:pointer, :pointer], :void
      attach_function :proj_get_insert_statements, :proj_get_insert_statements, [:pointer, :pointer, :pointer, :string, :string, :int, :pointer, :pointer], :pointer
      attach_function :proj_suggests_code_for, :proj_suggests_code_for, [:pointer, :pointer, :string, :int, :pointer], :pointer
      attach_function :proj_string_destroy, :proj_string_destroy, [:pointer], :void
      attach_function :proj_get_celestial_body_name, :proj_get_celestial_body_name, [:pointer, :pointer], :string
    end
    if proj_version >= 80200
      attach_function :proj_trans_bounds, :proj_trans_bounds, [:pointer, :pointer, PjDirection, :double, :double, :double, :double, :pointer, :pointer, :pointer, :pointer, :int], :int
      attach_function :proj_create_conversion_pole_rotation_netcdf_cf_convention, :proj_create_conversion_pole_rotation_netcdf_cf_convention, [:pointer, :double, :double, :double, :string, :double], :pointer
    end
    if proj_version >= 90100
      attach_function :proj_area_set_name, :proj_area_set_name, [:pointer, :string], :void
      attach_function :proj_trans_get_last_used_operation, :proj_trans_get_last_used_operation, [:pointer], :pointer
      attach_function :proj_operation_factory_context_set_area_of_interest_name, :proj_operation_factory_context_set_area_of_interest_name, [:pointer, :pointer, :string], :void
    end
    if proj_version >= 90200
      attach_function :proj_rtodms2, :proj_rtodms2, [:pointer, :size_t, :double, :int, :int], :pointer
      attach_function :proj_get_domain_count, :proj_get_domain_count, [:pointer], :int
      attach_function :proj_get_scope_ex, :proj_get_scope_ex, [:pointer, :int], :string
      attach_function :proj_get_area_of_use_ex, :proj_get_area_of_use_ex, [:pointer, :pointer, :int, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
      attach_function :proj_coordinate_metadata_get_epoch, :proj_coordinate_metadata_get_epoch, [:pointer, :pointer], :double
      attach_function :proj_create_conversion_tunisia_mining_grid, :proj_create_conversion_tunisia_mining_grid, [:pointer, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
    end
    if proj_version >= 90400
      attach_function :proj_crs_has_point_motion_operation, :proj_crs_has_point_motion_operation, [:pointer, :pointer], :int
      attach_function :proj_coordinate_metadata_create, :proj_coordinate_metadata_create, [:pointer, :pointer, :double], :pointer
      attach_function :proj_create_conversion_lambert_conic_conformal_1sp_variant_b, :proj_create_conversion_lambert_conic_conformal_1sp_variant_b, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
    end
    if proj_version >= 90500
      attach_function :proj_context_set_user_writable_directory, :proj_context_set_user_writable_directory, [:pointer, :string, :int], :void
      attach_function :proj_coordoperation_requires_per_coordinate_input_time, :proj_coordoperation_requires_per_coordinate_input_time, [:pointer, :pointer], :int
      attach_function :proj_create_conversion_local_orthographic, :proj_create_conversion_local_orthographic, [:pointer, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :pointer
    end
    if proj_version >= 90600
      attach_function :proj_trans_bounds_3d, :proj_trans_bounds_3D, [:pointer, :pointer, PjDirection, :double, :double, :double, :double, :double, :double, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :int], :int
    end
    if proj_version >= 90700
      attach_function :proj_geod_direct, :proj_geod_direct, [:pointer, PjCoord.by_value, :double, :double], PjCoord.by_value
    end
  end
end
