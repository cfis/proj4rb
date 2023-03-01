module Proj
  module Api
    # ----- Int List
    attach_function :proj_int_list_destroy, [:pointer], :void

    # ----- Object List
    typedef :pointer, :PJ_OBJ_LIST

    attach_function :proj_create_from_name, [:PJ_CONTEXT, :string, :string, :pointer, :size_t, :int, :size_t, :string], :PJ_OBJ_LIST
    attach_function :proj_get_non_deprecated, [:PJ_CONTEXT, :PJ], :PJ_OBJ_LIST
    attach_function :proj_identify, [:PJ_CONTEXT, :PJ, :string, :pointer, :pointer], :PJ_OBJ_LIST
    attach_function :proj_list_get_count, [:PJ_OBJ_LIST], :int
    attach_function :proj_list_get, [:PJ_CONTEXT, :PJ_OBJ_LIST, :int], :PJ
    attach_function :proj_list_destroy, [:PJ_OBJ_LIST], :void

    # ---- Units ------
    class PROJ_UNIT_INFO < FFI::Struct
      layout :auth_name, :string,
             :code, :string,
             :name, :string,
             :category, :string,
             :conv_factor, :double,
             :proj_short_name, :string,
             :deprecated, :int
    end

    attach_function :proj_get_units_from_database, [:PJ_CONTEXT, :string, :string, :int, :pointer], :pointer #Array of pointers to PROJ_UNIT_INFO
    attach_function :proj_unit_list_destroy, [:pointer], :void

    # ---- Operation Factories ------
    # Specifies how source and target CRS extent should be used to restrict candidate
    # operations (only taken into account if no explicit area of interest is specified.
    enum :PROJ_CRS_EXTENT_USE, [:PJ_CRS_EXTENT_NONE,   # Ignore CRS extent
                                :PJ_CRS_EXTENT_BOTH,   # Test extent against both CRS extent.
                                :PJ_CRS_EXTENT_INTERSECTION, # Test extent against the intersection of both CRS extents
                                :PJ_CRS_EXTENT_SMALLEST] # Test against the smallest of both CRS extent


    # Spatial criterion to restrict candidate operations
    enum :PROJ_SPATIAL_CRITERION, [:PROJ_SPATIAL_CRITERION_STRICT_CONTAINMENT, # The area of validity of transforms should strictly contain the area of interest
                                   :PROJ_SPATIAL_CRITERION_PARTIAL_INTERSECTION] # The area of validity of transforms should at least intersect the area of interest

    # Describe how grid availability is used
    enum :PROJ_GRID_AVAILABILITY_USE, [:PROJ_GRID_AVAILABILITY_USE, # Grid availability is only used for sorting results. Operations where some grids are missing will be sorted last
                                       :PROJ_GRID_AVAILABILITY_DISCARD_OPERATION_IF_MISSING_GRID, # Completely discard an operation if a required grid is missing
                                       :PROJ_GRID_AVAILABILITY_IGNORED, # Ignore grid availability at all. Results will be presented as if all grids were available
                                       :PROJ_GRID_AVAILABILITY_KNOWN_AVAILABLE] # Results will be presented as if grids known to PROJ (that is registered in the grid_alternatives table of its database) were available. Used typically when networking is enabled.

    # Describe if and how intermediate CRS should be used
    enum :PROJ_INTERMEDIATE_CRS_USE, [:PROJ_INTERMEDIATE_CRS_USE_ALWAYS, # Always search for intermediate CRS
                                      :PROJ_INTERMEDIATE_CRS_USE_IF_NO_DIRECT_TRANSFORMATION, # Only attempt looking for intermediate CRS if there is no direct transformation available
                                      :PROJ_INTERMEDIATE_CRS_USE_NEVER] # Do not attempt looking for intermediate CRS

    attach_function :proj_create_operation_factory_context, [:PJ_CONTEXT, :string], :PJ_OBJ_LIST
    attach_function :proj_operation_factory_context_destroy, [:pointer], :void
    attach_function :proj_create_operations, [:PJ_CONTEXT, :PJ, :PJ, :pointer], :pointer
    attach_function :proj_operation_factory_context_set_allow_ballpark_transformations, [:PJ_CONTEXT, :pointer, :int], :void
    attach_function :proj_operation_factory_context_set_desired_accuracy, [:PJ_CONTEXT, :pointer, :double], :void
    attach_function :proj_operation_factory_context_set_area_of_interest, [:PJ_CONTEXT, :pointer, :double, :double, :double, :double], :void
    attach_function :proj_operation_factory_context_set_area_of_interest_name, [:PJ_CONTEXT, :pointer, :string], :void
    attach_function :proj_operation_factory_context_set_crs_extent_use, [:PJ_CONTEXT, :pointer, :PROJ_CRS_EXTENT_USE], :void
    attach_function :proj_operation_factory_context_set_spatial_criterion, [:PJ_CONTEXT, :pointer, :PROJ_SPATIAL_CRITERION], :void
    attach_function :proj_operation_factory_context_set_grid_availability_use, [:PJ_CONTEXT, :pointer, :PROJ_GRID_AVAILABILITY_USE], :void
    attach_function :proj_operation_factory_context_set_use_proj_alternative_grid_names, [:PJ_CONTEXT, :pointer, :int], :void
    attach_function :proj_operation_factory_context_set_allow_use_intermediate_crs, [:PJ_CONTEXT, :pointer, :PROJ_INTERMEDIATE_CRS_USE], :void
    attach_function :proj_operation_factory_context_set_allowed_intermediate_crs, [:PJ_CONTEXT, :pointer, :pointer], :void
    attach_function :proj_operation_factory_context_set_discard_superseded, [:PJ_CONTEXT, :pointer, :int], :void

    # Operations
    attach_function :proj_coordoperation_has_ballpark_transformation, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_get_suggested_operation, [:PJ_CONTEXT, :PJ_OBJ_LIST, PJ_DIRECTION, PJ_COORD], :int
    attach_function :proj_coordoperation_get_param_count, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_coordoperation_get_param_index, [:PJ_CONTEXT, :PJ, :string], :int
    attach_function :proj_coordoperation_get_param, [:PJ_CONTEXT, :PJ, :int, :pointer, :pointer, :pointer,
                                                     :pointer, :pointer, :pointer, :pointer,:pointer, :pointer, :pointer], :int
    attach_function :proj_coordoperation_is_instantiable, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_coordoperation_get_grid_used_count, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_coordoperation_get_grid_used, [:PJ_CONTEXT, :PJ, :int,
                                                         :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int

    # Network
    attach_function :proj_context_get_url_endpoint, [:PJ_CONTEXT], :string
    attach_function :proj_context_get_user_writable_directory, [:PJ_CONTEXT, :int], :string
  end
end