# encoding: UTF-8
require 'stringio'

module Proj
  # Conversions are {CoordinateOperationMix coordinate operations} that convert a source
  # {Coordinate coordinate} to a new value. In Proj they are defined as operations that
  # do not exert a change in reference frame while {Transformation transformations } do.
  class Conversion < PjObject
    include CoordinateOperationMixin

    def self.create_conversion(context, name:, auth_name:, code:, method_name:, method_auth_name:, method_code:, param_count:, params:)
      ptr = Api.proj_create_conversion(context, name, auth_name, code, method_name, method_auth_name, method_code, param_count, params)
      self.create_object(ptr, context)
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
    # @see https://proj.org/development/reference/functions.html#c.proj_create
    #
    # @param value [String]. See above
    #
    # @return [Conversion]
    def initialize(value, context=nil)
      context ||= Context.current
      ptr = Api.proj_create(context, value)

      if ptr.null?
        Error.check_context(context)
      end

      if Api.method_defined?(:proj_is_crs) && Api.proj_is_crs(ptr)
        raise(Error, "Invalid conversion. Proj created an instance of: #{self.proj_type}.")
      end

      super(ptr, context)
    end
  end

  def convert_to_other_method(new_method_epsg_code, new_method_name)
    ptr = Api.proj_convert_conversion_to_other_method(self.context, self, new_method_epsg_code, new_method_name)
    self.create_object(ptr, context)
  end

  # Prebuilt conversions
  def self.utm(context, zone:, north:)
    ptr = Api.proj_create_conversion_utm(context, zone, north)
    self.create_object(ptr, context)
  end

  def self.transverse_mercator(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_transverse_mercator(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.gauss_schreiber_transverse_mercator(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_gauss_schreiber_transverse_mercator(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.transverse_mercator_south_oriented(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_transverse_mercator_south_oriented(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.two_point_equidistant(context, latitude_first_point:, longitude_first_point:, latitude_second_point:, longitude_secon_point:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_two_point_equidistant(context, latitude_first_point, longitude_first_point, latitude_second_point, longitude_secon_point, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.tunisia_mapping_grid(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_tunisia_mapping_grid(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.tunisia_mining_grid(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_tunisia_mining_grid(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.albers_equal_area(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_albers_equal_area(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.lambert_conic_conformal_1sp(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_lambert_conic_conformal_1sp(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.lambert_conic_conformal_2sp(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.lambert_conic_conformal_2sp_michigan(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ellipsoid_scaling_factor:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp_michigan(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ellipsoid_scaling_factor, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.lambert_conic_conformal_2sp_belgium(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp_belgium(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.azimuthal_equidistant(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_azimuthal_equidistant(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.guam_projection(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_guam_projection(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.bonne(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_bonne(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.lambert_cylindrical_equal_area(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_lambert_cylindrical_equal_area(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.cassini_soldner(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_cassini_soldner(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.equidistant_conic(context, center_lat:, center_long:, latitude_first_parallel:, latitude_second_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_equidistant_conic(context, center_lat, center_long, latitude_first_parallel, latitude_second_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.eckert_i(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_eckert_i(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.eckert_ii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_eckert_ii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.eckert_iii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_eckert_iii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.eckert_iv(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_eckert_iv(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.eckert_v(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_eckert_v(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.eckert_vi(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_eckert_vi(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.equidistant_cylindrical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_equidistant_cylindrical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.equidistant_cylindrical_spherical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_equidistant_cylindrical_spherical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.gall(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_gall(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.goode_homolosine(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_goode_homolosine(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.interrupted_goode_homolosine(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_interrupted_goode_homolosine(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.geostationary_satellite_sweep_x(context, center_long:, height:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_geostationary_satellite_sweep_x(context, center_long, height, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.geostationary_satellite_sweep_y(context, center_long:, height:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_geostationary_satellite_sweep_y(context, center_long, height, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.gnomonic(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_gnomonic(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.hotine_oblique_mercator_variant_a(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, angle_from_rectified_to_skrew_grid:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_hotine_oblique_mercator_variant_a(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, angle_from_rectified_to_skrew_grid, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.hotine_oblique_mercator_variant_b(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, angle_from_rectified_to_skrew_grid:, scale:, easting_projection_centre:, northing_projection_centre:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_hotine_oblique_mercator_variant_b(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, angle_from_rectified_to_skrew_grid, scale, easting_projection_centre, northing_projection_centre, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre:, latitude_point1:, longitude_point1:, latitude_point2:, longitude_point2:, scale:, easting_projection_centre:, northing_projection_centre:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre, latitude_point1, longitude_point1, latitude_point2, longitude_point2, scale, easting_projection_centre, northing_projection_centre, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.laborde_oblique_mercator(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_laborde_oblique_mercator(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.international_map_world_polyconic(context, center_long:, latitude_first_parallel:, latitude_second_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_international_map_world_polyconic(context, center_long, latitude_first_parallel, latitude_second_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.krovak_north_oriented(context, latitude_projection_centre:, longitude_of_origin:, colatitude_cone_axis:, latitude_pseudo_standard_parallel:, scale_factor_pseudo_standard_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_krovak_north_oriented(context, latitude_projection_centre, longitude_of_origin, colatitude_cone_axis, latitude_pseudo_standard_parallel, scale_factor_pseudo_standard_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.krovak(context, latitude_projection_centre:, longitude_of_origin:, colatitude_cone_axis:, latitude_pseudo_standard_parallel:, scale_factor_pseudo_standard_parallel:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_krovak(context, latitude_projection_centre, longitude_of_origin, colatitude_cone_axis, latitude_pseudo_standard_parallel, scale_factor_pseudo_standard_parallel, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.lambert_azimuthal_equal_area(context, latitude_nat_origin:, longitude_nat_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_lambert_azimuthal_equal_area(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.miller_cylindrical(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_miller_cylindrical(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.mercator_variant_a(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_mercator_variant_a(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.mercator_variant_b(context, latitude_first_parallel:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_mercator_variant_b(context, latitude_first_parallel, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.popular_visualisation_pseudo_mercator(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_popular_visualisation_pseudo_mercator(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.mollweide(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_mollweide(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.new_zealand_mapping_grid(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_new_zealand_mapping_grid(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.oblique_stereographic(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_oblique_stereographic(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.orthographic(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_orthographic(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.american_polyconic(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_american_polyconic(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.polar_stereographic_variant_a(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_polar_stereographic_variant_a(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.polar_stereographic_variant_b(context, latitude_standard_parallel:, longitude_of_origin:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_polar_stereographic_variant_b(context, latitude_standard_parallel, longitude_of_origin, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.robinson(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_robinson(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.sinusoidal(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_sinusoidal(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.stereographic(context, center_lat:, center_long:, scale:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_stereographic(context, center_lat, center_long, scale, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.van_der_grinten(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_van_der_grinten(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.wagner_i(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_wagner_i(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.wagner_ii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_wagner_ii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.wagner_iii(context, latitude_true_scale:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_wagner_iii(context, latitude_true_scale, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.wagner_iv(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_wagner_iv(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.wagner_v(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_wagner_v(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.wagner_vi(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_wagner_vi(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.wagner_vii(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_wagner_vii(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.quadrilateralized_spherical_cube(context, center_lat:, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_quadrilateralized_spherical_cube(context, center_lat, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.spherical_cross_track_height(context, peg_point_lat:, peg_point_long:, peg_point_heading:, peg_point_height:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_spherical_cross_track_height(context, peg_point_lat, peg_point_long, peg_point_heading, peg_point_height, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.equal_earth(context, center_long:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_equal_earth(context, center_long, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.vertical_perspective(context, topo_origin_lat:, topo_origin_long:, topo_origin_height:, view_point_height:, false_easting:, false_northing:, ang_unit_name:, ang_unit_conv_factor:, linear_unit_name:, linear_unit_conv_factor:)
    ptr = Api.proj_create_conversion_vertical_perspective(context, topo_origin_lat, topo_origin_long, topo_origin_height, view_point_height, false_easting, false_northing, ang_unit_name, ang_unit_conv_factor, linear_unit_name, linear_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.pole_rotation_grib_convention(context, south_pole_lat_in_unrotated_crs:, south_pole_long_in_unrotated_crs:, axis_rotation:, ang_unit_name:, ang_unit_conv_factor:)
    ptr = Api.proj_create_conversion_pole_rotation_grib_convention(context, south_pole_lat_in_unrotated_crs, south_pole_long_in_unrotated_crs, axis_rotation, ang_unit_name, ang_unit_conv_factor)
    self.create_object(ptr, context)
  end

  def self.pole_rotation_netcdf_cf_convention(context, grid_north_pole_latitude:, grid_north_pole_longitude:, north_pole_grid_longitude:, ang_unit_name:, ang_unit_conv_factor:)
    ptr = Api.proj_create_conversion_pole_rotation_netcdf_cf_convention(context, grid_north_pole_latitude, grid_north_pole_longitude, north_pole_grid_longitude, ang_unit_name, ang_unit_conv_factor)
    self.create_object(ptr, context)
  end
end
