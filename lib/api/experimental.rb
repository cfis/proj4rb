module Proj
  module Api

    PJ_UNIT_TYPE = enum(:PJ_UT_ANGULAR,
                       :PJ_UT_LINEAR,
                       :PJ_UT_SCALE,
                       :PJ_UT_TIME)

    PJ_CARTESIAN_CS_2D_TYPE = enum(:PJ_CART2D_EASTING_NORTHING,
                                   :PJ_CART2D_NORTHING_EASTING,
                                   :PJ_CART2D_NORTH_POLE_EASTING_SOUTH_NORTHING_SOUTH,
                                   :PJ_CART2D_SOUTH_POLE_EASTING_NORTH_NORTHING_NORTH,
                                   :PJ_CART2D_WESTING_SOUTHING)

    PJ_ELLIPSOIDAL_CS_2D_TYPE = enum(:PJ_ELLPS2D_LONGITUDE_LATITUDE,
                                     :PJ_ELLPS2D_LATITUDE_LONGITUDE)

    PJ_ELLIPSOIDAL_CS_3D_TYPE = enum(:PJ_ELLPS3D_LONGITUDE_LATITUDE_HEIGHT,
                                     :PJ_ELLPS3D_LATITUDE_LONGITUDE_HEIGHT)


    class PJ_AXIS_DESCRIPTION < FFI::Struct
      layout :name, :string,
             :abbreviation, :string,
             :direction, :string,
             :unit_name, :string,
             :unit_conv_factor, :double,
             :unit_type, PJ_UNIT_TYPE
    end

    class PJ_PARAM_DESCRIPTION < FFI::Struct
      layout :name, :string,
             :auth_name, :string,
             :code, :string,
             :value, :double,
             :unit_name, :string,
             :unit_conv_factor, :double,
             :unit_type, PJ_UNIT_TYPE
    end 

    # Create coordinate systems
    attach_function :proj_create_cs, [:PJ_CONTEXT, PJ_COORDINATE_SYSTEM_TYPE, :int, :pointer], :PJ
    attach_function :proj_create_cartesian_2D_cs, [:PJ_CONTEXT, PJ_CARTESIAN_CS_2D_TYPE, :string, :double], :PJ
    attach_function :proj_create_ellipsoidal_2D_cs, [:PJ_CONTEXT, PJ_ELLIPSOIDAL_CS_2D_TYPE, :string, :double], :PJ
    attach_function :proj_create_ellipsoidal_3D_cs, [:PJ_CONTEXT, PJ_ELLIPSOIDAL_CS_3D_TYPE, :string, :double, :string, :double], :PJ

    # Create CRSes
    attach_function :proj_query_geodetic_crs_from_datum, [:PJ_CONTEXT, :string, :string, :string, :string], :PJ_OBJ_LIST
    attach_function :proj_create_geographic_crs, [:PJ_CONTEXT, :string, :string, :string, :double, :double, :string, :double, :string, :double, :PJ], :PJ
    attach_function :proj_create_geographic_crs_from_datum, [:PJ_CONTEXT, :string, :PJ, :PJ], :PJ
    attach_function :proj_create_geocentric_crs, [:PJ_CONTEXT, :string, :string, :string, :double, :double, :string, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_geocentric_crs_from_datum, [:PJ_CONTEXT, :string, :PJ, :string, :double], :PJ
    attach_function :proj_create_derived_geographic_crs, [:PJ_CONTEXT, :string, :PJ, :PJ, :PJ], :PJ
    attach_function :proj_is_derived_crs, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_alter_name, [:PJ_CONTEXT, :PJ, :string], :PJ
    attach_function :proj_alter_id, [:PJ_CONTEXT, :PJ, :string, :string], :PJ
    attach_function :proj_crs_alter_geodetic_crs, [:PJ_CONTEXT, :PJ, :PJ], :PJ
    attach_function :proj_crs_alter_cs_angular_unit, [:PJ_CONTEXT, :PJ, :string, :double, :string, :string], :PJ
    attach_function :proj_crs_alter_cs_linear_unit, [:PJ_CONTEXT, :PJ, :string, :double, :string, :string], :PJ
    attach_function :proj_crs_alter_parameters_linear_unit, [:PJ_CONTEXT, :PJ, :string, :double, :string, :string, :int], :PJ
    attach_function :proj_crs_promote_to_3D, [:PJ_CONTEXT, :string, :PJ], :PJ
    attach_function :proj_crs_create_projected_3D_crs_from_2D, [:PJ_CONTEXT, :string, :PJ, :PJ], :PJ
    attach_function :proj_crs_demote_to_2D, [:PJ_CONTEXT, :string, :PJ], :PJ
    attach_function :proj_create_engineering_crs, [:PJ_CONTEXT, :string], :PJ
    attach_function :proj_create_vertical_crs, [:PJ_CONTEXT, :string, :string, :string, :double], :PJ
    attach_function :proj_create_vertical_crs_ex, [:PJ_CONTEXT, :string, :string, :string, :string, :string, :double, :string, :string, :string, :PJ, :string], :PJ
    attach_function :proj_create_compound_crs, [:PJ_CONTEXT, :string, :PJ, :PJ], :PJ
    attach_function :proj_create_projected_crs, [:PJ_CONTEXT, :string, :PJ, :PJ, :PJ], :PJ
    attach_function :proj_crs_create_bound_crs, [:PJ_CONTEXT, :PJ, :PJ, :PJ], :PJ
    attach_function :proj_crs_create_bound_crs_to_WGS84, [:PJ_CONTEXT, :PJ, :string], :PJ
    attach_function :proj_crs_create_bound_vertical_crs, [:PJ_CONTEXT, :PJ, :PJ, :string], :PJ

    # Transformation
    attach_function :proj_create_transformation, [:PJ_CONTEXT, :string, :string, :string, :PJ, :PJ, :PJ, :string, :string, :string, :int, PJ_PARAM_DESCRIPTION.by_ref, :double], :PJ

    # Conversion
    attach_function :proj_create_conversion, [:PJ_CONTEXT, :string, :string, :string, :string, :string, :string, :int, PJ_PARAM_DESCRIPTION.by_ref], :PJ
    attach_function :proj_convert_conversion_to_other_method, [:PJ_CONTEXT, :PJ, :int, :string], :PJ
    attach_function :proj_create_conversion_utm, [:PJ_CONTEXT, :int, :int], :PJ
    attach_function :proj_create_conversion_transverse_mercator, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_gauss_schreiber_transverse_mercator, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_transverse_mercator_south_oriented, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_two_point_equidistant, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_tunisia_mapping_grid, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_albers_equal_area, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_lambert_conic_conformal_1sp, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_lambert_conic_conformal_2sp, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_lambert_conic_conformal_2sp_michigan, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_lambert_conic_conformal_2sp_belgium, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_azimuthal_equidistant, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_guam_projection, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_bonne, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_lambert_cylindrical_equal_area_spherical, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_lambert_cylindrical_equal_area, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_cassini_soldner, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_equidistant_conic, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_eckert_i, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_eckert_ii, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_eckert_iii, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_eckert_iv, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_eckert_v, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_eckert_vi, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_equidistant_cylindrical, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_equidistant_cylindrical_spherical, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_gall, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_goode_homolosine, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_interrupted_goode_homolosine, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_geostationary_satellite_sweep_x, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_geostationary_satellite_sweep_y, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_gnomonic, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_hotine_oblique_mercator_variant_a, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_hotine_oblique_mercator_variant_b, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_hotine_oblique_mercator_two_point_natural_origin, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_laborde_oblique_mercator, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_international_map_world_polyconic, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_krovak_north_oriented, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_krovak, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_lambert_azimuthal_equal_area, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_miller_cylindrical, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_mercator_variant_a, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_mercator_variant_b, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_popular_visualisation_pseudo_mercator, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_mollweide, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_new_zealand_mapping_grid, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_oblique_stereographic, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_orthographic, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_american_polyconic, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_polar_stereographic_variant_a, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_polar_stereographic_variant_b, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_robinson, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_sinusoidal, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_stereographic, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_van_der_grinten, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_wagner_i, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_wagner_ii, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_wagner_iii, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_wagner_iv, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_wagner_v, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_wagner_vi, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_wagner_vii, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_quadrilateralized_spherical_cube, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_spherical_cross_track_height, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_equal_earth, [:PJ_CONTEXT, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_vertical_perspective, [:PJ_CONTEXT, :double, :double, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_pole_rotation_grib_convention, [:PJ_CONTEXT, :double, :double, :double, :string, :double], :PJ
    attach_function :proj_create_conversion_pole_rotation_netcdf_cf_convention, [:PJ_CONTEXT, :double, :double, :double, :string, :double], :PJ

    #attach_function :proj_create_conversion_tunisia_mining_grid, [:PJ_CONTEXT, :double, :double, :double, :double, :string, :double, :string, :double], :PJ
  end
end