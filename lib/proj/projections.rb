# encoding: UTF-8
require 'stringio'

module Proj
  # Projections are coordinate operations that are conversions. For more information about each
  # projection @see https://proj.org/operations/projections/index.html
  module Projections
    def utm(context, zone:, north:)
      ptr = Api.proj_create_conversion_utm(context, zone, north)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def transverse_mercator(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_transverse_mercator(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def gauss_schreiber_transverse_mercator(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_gauss_schreiber_transverse_mercator(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def transverse_mercator_south_oriented(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_transverse_mercator_south_oriented(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def two_point_equidistant(context, latitude_first_point:, longitude_first_point:, latitude_second_point:, longitude_secon_point:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_two_point_equidistant(context, latitude_first_point, longitude_first_point, latitude_second_point, longitude_secon_point, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def tunisia_mapping_grid(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_tunisia_mapping_grid(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def tunisia_mining_grid(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_tunisia_mining_grid(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def albers_equal_area(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_albers_equal_area(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def lambert_conic_conformal_1sp(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_1sp(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def lambert_conic_conformal_2sp(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def lambert_conic_conformal_2sp_michigan(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ellipsoid_scaling_factor:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp_michigan(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ellipsoid_scaling_factor, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def lambert_conic_conformal_2sp_belgium(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp_belgium(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def azimuthal_equidistant(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_azimuthal_equidistant(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def guam_projection(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_guam_projection(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def bonne(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_bonne(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def lambert_cylindrical_equal_area(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_lambert_cylindrical_equal_area(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def cassini_soldner(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_cassini_soldner(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def equidistant_conic(context, center_lat:, center_long:, latitude_first_parallel:, latitude_second_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_equidistant_conic(context, center_lat, center_long, latitude_first_parallel, latitude_second_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def eckert_i(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_eckert_i(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def eckert_ii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_eckert_ii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def eckert_iii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_eckert_iii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def eckert_iv(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_eckert_iv(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def eckert_v(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_eckert_v(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def eckert_vi(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_eckert_vi(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def equidistant_cylindrical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_equidistant_cylindrical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def equidistant_cylindrical_spherical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_equidistant_cylindrical_spherical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def gall(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_gall(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def goode_homolosine(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_goode_homolosine(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def interrupted_goode_homolosine(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_interrupted_goode_homolosine(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def geostationary_satellite_sweep_x(context, center_long:, height:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_geostationary_satellite_sweep_x(context, center_long, height, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def geostationary_satellite_sweep_y(context, center_long:, height:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_geostationary_satellite_sweep_y(context, center_long, height, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def gnomonic(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_gnomonic(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def hotine_oblique_mercator_variant_a(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, angle_from_rectified_to_skrew_grid:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_hotine_oblique_mercator_variant_a(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, angle_from_rectified_to_skrew_grid, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def hotine_oblique_mercator_variant_b(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, angle_from_rectified_to_skrew_grid:, scale:, easting_projection_centre:, northing_projection_centre:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_hotine_oblique_mercator_variant_b(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, angle_from_rectified_to_skrew_grid, scale, easting_projection_centre, northing_projection_centre, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre:, latitude_point1:, longitude_point1:, latitude_point2:, longitude_point2:, scale:, easting_projection_centre:, northing_projection_centre:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre, latitude_point1, longitude_point1, latitude_point2, longitude_point2, scale, easting_projection_centre, northing_projection_centre, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def laborde_oblique_mercator(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_laborde_oblique_mercator(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def international_map_world_polyconic(context, center_long:, latitude_first_parallel:, latitude_second_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_international_map_world_polyconic(context, center_long, latitude_first_parallel, latitude_second_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def krovak_north_oriented(context, latitude_projection_centre:, longitude_of_origin:, colatitude_cone_axis:, latitude_pseudo_standard_parallel:, scale_factor_pseudo_standard_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_krovak_north_oriented(context, latitude_projection_centre, longitude_of_origin, colatitude_cone_axis, latitude_pseudo_standard_parallel, scale_factor_pseudo_standard_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def krovak(context, latitude_projection_centre:, longitude_of_origin:, colatitude_cone_axis:, latitude_pseudo_standard_parallel:, scale_factor_pseudo_standard_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_krovak(context, latitude_projection_centre, longitude_of_origin, colatitude_cone_axis, latitude_pseudo_standard_parallel, scale_factor_pseudo_standard_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def lambert_azimuthal_equal_area(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_lambert_azimuthal_equal_area(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def miller_cylindrical(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_miller_cylindrical(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def mercator_variant_a(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_mercator_variant_a(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def mercator_variant_b(context, latitude_first_parallel:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_mercator_variant_b(context, latitude_first_parallel, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def popular_visualisation_pseudo_mercator(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_popular_visualisation_pseudo_mercator(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def mollweide(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_mollweide(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def new_zealand_mapping_grid(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_new_zealand_mapping_grid(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def oblique_stereographic(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_oblique_stereographic(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def orthographic(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_orthographic(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def american_polyconic(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_american_polyconic(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def polar_stereographic_variant_a(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_polar_stereographic_variant_a(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def polar_stereographic_variant_b(context, latitude_standard_parallel:, longitude_of_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_polar_stereographic_variant_b(context, latitude_standard_parallel, longitude_of_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def robinson(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_robinson(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def sinusoidal(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_sinusoidal(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def stereographic(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_stereographic(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def van_der_grinten(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_van_der_grinten(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def wagner_i(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_wagner_i(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def wagner_ii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_wagner_ii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def wagner_iii(context, latitude_true_scale:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_wagner_iii(context, latitude_true_scale, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def wagner_iv(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_wagner_iv(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def wagner_v(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_wagner_v(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def wagner_vi(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_wagner_vi(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def wagner_vii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_wagner_vii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def quadrilateralized_spherical_cube(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_quadrilateralized_spherical_cube(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def spherical_cross_track_height(context, peg_point_lat:, peg_point_long:, peg_point_heading:, peg_point_height:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_spherical_cross_track_height(context, peg_point_lat, peg_point_long, peg_point_heading, peg_point_height, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def equal_earth(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_equal_earth(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def vertical_perspective(context, topo_origin_lat:, topo_origin_long:, topo_origin_height:, view_point_height:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
      ptr = Api.proj_create_conversion_vertical_perspective(context, topo_origin_lat, topo_origin_long, topo_origin_height, view_point_height, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def pole_rotation_grib_convention(context, south_pole_lat_in_unrotated_crs:, south_pole_long_in_unrotated_crs:, axis_rotation:, ang_unit_name:, ang_unit_conv_factor:)
      ptr = Api.proj_create_conversion_pole_rotation_grib_convention(context, south_pole_lat_in_unrotated_crs, south_pole_long_in_unrotated_crs, axis_rotation, ang_unit_name, ang_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end

    def pole_rotation_netcdf_cf_convention(context, grid_north_pole_latitude:, grid_north_pole_longitude:, north_pole_grid_longitude:, ang_unit_name:, ang_unit_conv_factor:)
      ptr = Api.proj_create_conversion_pole_rotation_netcdf_cf_convention(context, grid_north_pole_latitude, grid_north_pole_longitude, north_pole_grid_longitude, ang_unit_name, ang_unit_conv_factor)

      if ptr.null?
        Error.check_context(context)
      end

      self.create_object(ptr, context)
    end
  end
end
