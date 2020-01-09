module Proj
  module Api
    callback :proj_file_finder, [:PJ_CONTEXT, :string, :pointer], :string
    attach_function :proj_context_set_file_finder, [:PJ_CONTEXT, :proj_file_finder, :pointer], :void
    attach_function :proj_context_set_search_paths, [:PJ_CONTEXT, :int, :pointer], :void

    attach_function :proj_context_use_proj4_init_rules, [:PJ_CONTEXT, :int], :void
    attach_function :proj_context_get_use_proj4_init_rules, [:PJ_CONTEXT, :int], :bool
    attach_function :proj_list_angular_units, [], :pointer #PJ_UNITS

    # Base methods
    attach_function :proj_get_name, [:PJ], :string
    attach_function :proj_get_id_auth_name, [:PJ, :int], :string
    attach_function :proj_get_id_code, [:PJ, :int], :string
    attach_function :proj_get_type, [:PJ], :PJ_TYPE
    attach_function :proj_is_deprecated, [:PJ], :bool
    attach_function :proj_is_crs, [:PJ], :bool
    attach_function :proj_get_area_of_use, [:PJ_CONTEXT, :PJ, :pointer, :pointer, :pointer, :pointer, :pointer], :bool

    # Export to various formats
    attach_function :proj_as_wkt, [:PJ_CONTEXT, :PJ, :PJ_WKT_TYPE, :pointer], :string
    attach_function :proj_as_proj_string, [:PJ_CONTEXT, :PJ, :PJ_PROJ_STRING_TYPE, :pointer], :string

    # Projection database functions
    attach_function :proj_context_set_autoclose_database, [:PJ_CONTEXT, :int], :void
    attach_function :proj_context_set_database_path, [:PJ_CONTEXT, :string, :pointer, :pointer], :int
    attach_function :proj_context_get_database_path, [:PJ_CONTEXT], :string
    attach_function :proj_context_get_database_metadata, [:PJ_CONTEXT, :string], :string

    # CRS methods
    attach_function :proj_crs_get_geodetic_crs, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_horizontal_datum, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_sub_crs, [:PJ_CONTEXT, :PJ, :int], :PJ
    attach_function :proj_crs_get_datum, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_coordinate_system, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_cs_get_type, [:PJ_CONTEXT, :PJ], :PJ_COORDINATE_SYSTEM_TYPE
    attach_function :proj_cs_get_axis_count, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_cs_get_axis_info, [:PJ_CONTEXT, :PJ, :int, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
    attach_function :proj_get_prime_meridian, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_get_ellipsoid, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_coordoperation, [:PJ_CONTEXT, :PJ], :PJ
  end
end