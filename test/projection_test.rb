# encoding: UTF-8

require_relative './abstract_test'

class ProjectionTest < AbstractTest
  def test_utm
    context = Proj::Context.new
    proj = Proj::Projection.utm(context, zone: 1, north: 0)
    assert(proj)
  end

  def test_transverse_mercator
    context = Proj::Context.new
    proj = Proj::Projection.transverse_mercator(context, center_latitude: 0, center_longitude: 0,
                                                scale: 1, false_easting: 0, false_northing: 0,
                                                angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_gauss_schreiber_transverse_mercator
    context = Proj::Context.new
    proj = Proj::Projection.gauss_schreiber_transverse_mercator(context, center_latitude: 0, center_longitude: 0,
                                                                scale: 1, false_easting: 0, false_northing: 0,
                                                                angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                                linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_transverse_mercator_south_oriented
    context = Proj::Context.new
    proj = Proj::Projection.transverse_mercator_south_oriented(context, center_latitude: 0, center_longitude: 0,
                                                               scale: 1, false_easting: 0, false_northing: 0,
                                                               angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                               linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_two_point_equidistant
    context = Proj::Context.new

    proj = Proj::Projection.two_point_equidistant(context,
                                                  latitude_first_point: 0, longitude_first_point: 0,
                                                  latitude_second_point: 0, longitude_second_point: 0,
                                                  false_easting: 0, false_northing: 0,
                                                  angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  if Proj::Api::PROJ_VERSION >= Gem::Version.new('9.2.0')
  def test_tunisia_mining_grid
    context = Proj::Context.new
    proj = Proj::Projection.tunisia_mining_grid(context, center_latitude: 0, center_longitude: 0,
                                                false_easting: 0, false_northing: 0,
                                                angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end
  end

  def test_albers_equal_area
    context = Proj::Context.new

    proj = Proj::Projection.albers_equal_area(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                              latitude_first_parallel: 0, latitude_second_parallel: 0,
                                              easting_false_origin: 0, northing_false_origin: 0,
                                              angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                              linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_lambert_conic_conformal_1sp
    context = Proj::Context.new
    proj = Proj::Projection.lambert_conic_conformal_1sp(context, center_latitude: 0, center_longitude: 0, scale: 1,
                                                        false_easting: 0, false_northing: 0,
                                                        angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                        linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  if Proj::Api::PROJ_VERSION >= Gem::Version.new('9.4.0')
    def test_lambert_conic_conformal_1sp_variant_b_argument_order
      context = Proj::Context.new
      captured_args = nil
      api_singleton = Proj::Api.singleton_class
      conversion_singleton = Proj::Conversion.singleton_class

      api_singleton.class_eval do
        alias_method :__orig_proj_create_conversion_lambert_conic_conformal_1sp_variant_b, :proj_create_conversion_lambert_conic_conformal_1sp_variant_b
        define_method(:proj_create_conversion_lambert_conic_conformal_1sp_variant_b) do |*args|
          captured_args = args
          FFI::MemoryPointer.new(:char, 1)
        end
      end

      conversion_singleton.class_eval do
        alias_method :__orig_create_object, :create_object
        define_method(:create_object) do |_ptr, _context|
          :ok
        end
      end

      result = Proj::Projection.lambert_conic_conformal_1sp_variant_b(context,
                                                                       latitude_nat_origin: 11,
                                                                       scale: 22,
                                                                       latitude_false_origin: 33,
                                                                       longitude_false_origin: 44,
                                                                       easting_false_origin: 55,
                                                                       northing_false_origin: 66,
                                                                       angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                                       linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)

      assert_equal(:ok, result)
      assert_equal([context, 11, 22, 33, 44, 55, 66, "Degree", 0.0174532925199433, "Metre", 1.0], captured_args)
    ensure
      conversion_singleton.class_eval do
        remove_method :create_object
        alias_method :create_object, :__orig_create_object
        remove_method :__orig_create_object
      end

      api_singleton.class_eval do
        remove_method :proj_create_conversion_lambert_conic_conformal_1sp_variant_b
        alias_method :proj_create_conversion_lambert_conic_conformal_1sp_variant_b, :__orig_proj_create_conversion_lambert_conic_conformal_1sp_variant_b
        remove_method :__orig_proj_create_conversion_lambert_conic_conformal_1sp_variant_b
      end
    end
  end

  def test_lambert_conic_conformal_2sp
    context = Proj::Context.new
    proj = Proj::Projection.lambert_conic_conformal_2sp(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                                        latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                        easting_false_origin: 0, northing_false_origin: 0,
                                                        angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                        linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_lambert_conic_conformal_2sp_michigan
    context = Proj::Context.new
    proj = Proj::Projection.lambert_conic_conformal_2sp_michigan(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                                                 latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                                 easting_false_origin: 0, northing_false_origin: 0,
                                                                 ellipsoid_scaling_factor: 0,
                                                                 angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                                 linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_lambert_conic_conformal_2sp_belgium
    context = Proj::Context.new
    proj = Proj::Projection.lambert_conic_conformal_2sp_belgium(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                                                latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                                easting_false_origin: 0, northing_false_origin: 0,
                                                                angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                                linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_azimuthal_equidistant
    context = Proj::Context.new
    proj = Proj::Projection.azimuthal_equidistant(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                                  false_easting: 0, false_northing: 0,
                                                  angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)

    assert(proj)
  end

  def test_guam_projection
    context = Proj::Context.new
    proj = Proj::Projection.guam_projection(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                            false_easting: 0, false_northing: 0,
                                            angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                            linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_bonne
    context = Proj::Context.new
    proj = Proj::Projection.bonne(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                  false_easting: 0, false_northing: 0,
                                  angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                  linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_lambert_cylindrical_equal_area_spherical
    context = Proj::Context.new
    proj = Proj::Projection.lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                                     false_easting: 0, false_northing: 0,
                                                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)

    assert(proj)
  end

  def test_lambert_cylindrical_equal_area
    context = Proj::Context.new
    proj = Proj::Projection.lambert_cylindrical_equal_area(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                           false_easting: 0, false_northing: 0,
                                                           angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                           linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_cassini_soldner
    context = Proj::Context.new
    proj = Proj::Projection.cassini_soldner(context, center_latitude: 0, center_longitude: 0,
                                            false_easting: 0, false_northing: 0,
                                            angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                            linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_equidistant_conic
    context = Proj::Context.new
    proj = Proj::Projection.equidistant_conic(context, center_latitude: 0, center_longitude: 0,
                                              latitude_first_parallel: 0, latitude_second_parallel: 0,
                                              false_easting: 0, false_northing: 0,
                                              angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                              linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_eckert_i
    context = Proj::Context.new
    proj = Proj::Projection.eckert_i(context, center_longitude: 0,
                                     false_easting: 0, false_northing: 0,
                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_eckert_ii
    context = Proj::Context.new
    proj = Proj::Projection.eckert_ii(context, center_longitude: 0,
                                      false_easting: 0, false_northing: 0,
                                      angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_eckert_iii
    context = Proj::Context.new
    proj = Proj::Projection.eckert_iii(context, center_longitude: 0,
                                       false_easting: 0, false_northing: 0,
                                       angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_eckert_iv
    context = Proj::Context.new
    proj = Proj::Projection.eckert_iv(context, center_longitude: 0,
                                      false_easting: 0, false_northing: 0,
                                      angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_eckert_v
    context = Proj::Context.new
    proj = Proj::Projection.eckert_v(context, center_longitude: 0,
                                     false_easting: 0, false_northing: 0,
                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_eckert_vi
    context = Proj::Context.new
    proj = Proj::Projection.eckert_vi(context, center_longitude: 0,
                                      false_easting: 0, false_northing: 0,
                                      angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_equidistant_cylindrical
    context = Proj::Context.new
    proj = Proj::Projection.equidistant_cylindrical(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                    false_easting: 0, false_northing: 0,
                                                    angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                    linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_equidistant_cylindrical_spherical
    context = Proj::Context.new
    proj = Proj::Projection.equidistant_cylindrical_spherical(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                              false_easting: 0, false_northing: 0,
                                                              angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_gall
    context = Proj::Context.new
    proj = Proj::Projection.gall(context, center_longitude: 0,
                                 false_easting: 0, false_northing: 0,
                                 angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                 linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_goode_homolosine
    context = Proj::Context.new
    proj = Proj::Projection.goode_homolosine(context, center_longitude: 0,
                                             false_easting: 0, false_northing: 0,
                                             angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                             linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_interrupted_goode_homolosine
    context = Proj::Context.new
    proj = Proj::Projection.interrupted_goode_homolosine(context, center_longitude: 0,
                                                         false_easting: 0, false_northing: 0,
                                                         angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                         linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_geostationary_satellite_sweep_x
    context = Proj::Context.new
    proj = Proj::Projection.geostationary_satellite_sweep_x(context, center_longitude: 0, height: 0,
                                                            false_easting: 0, false_northing: 0,
                                                            angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                            linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_geostationary_satellite_sweep_y
    context = Proj::Context.new
    proj = Proj::Projection.geostationary_satellite_sweep_y(context, center_longitude: 0, height: 0,
                                                            false_easting: 0, false_northing: 0,
                                                            angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                            linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_gnomonic
    context = Proj::Context.new
    proj = Proj::Projection.gnomonic(context, center_latitude: 0, center_longitude: 0,
                                     false_easting: 0, false_northing: 0,
                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_hotine_oblique_mercator_variant_a
    context = Proj::Context.new
    proj = Proj::Projection.hotine_oblique_mercator_variant_a(context,
                                                              latitude_projection_centre: 0, longitude_projection_centre: 0,
                                                              azimuth_initial_line: 0, angle_from_rectified_to_skrew_grid: 0,
                                                              scale: 1,
                                                              false_easting: 0, false_northing: 0,
                                                              angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_hotine_oblique_mercator_variant_b
    context = Proj::Context.new
    proj = Proj::Projection.hotine_oblique_mercator_variant_b(context,
                                                              latitude_projection_centre: 0, longitude_projection_centre: 0,
                                                              azimuth_initial_line: 0, angle_from_rectified_to_skrew_grid: 0,
                                                              scale: 1,
                                                              easting_projection_centre: 0,  northing_projection_centre: 0,
                                                              angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_hotine_oblique_mercator_two_point_natural_origin
    context = Proj::Context.new
    proj = Proj::Projection.hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre: 0,
                                                                             latitude_point1: 0, longitude_point1: 0,
                                                                             latitude_point2: 0, longitude_point2: 0,
                                                                             scale: 1,
                                                                             easting_projection_centre: 0, northing_projection_centre: 0,
                                                                             angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                                             linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_laborde_oblique_mercator
    context = Proj::Context.new
    proj = Proj::Projection.laborde_oblique_mercator(context, latitude_projection_centre: 0, longitude_projection_centre: 0,
                                                     azimuth_initial_line: 0,
                                                     scale: 1,
                                                     false_easting: 0, false_northing: 0,
                                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_international_map_world_polyconic
    context = Proj::Context.new
    proj = Proj::Projection.international_map_world_polyconic(context, center_longitude: 0,
                                                              latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                              false_easting: 0, false_northing: 0,
                                                              angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_krovak_north_oriented
    context = Proj::Context.new
    proj = Proj::Projection.krovak_north_oriented(context, latitude_projection_centre: 0, longitude_of_origin: 0,
                                                  colatitude_cone_axis: 0, latitude_pseudo_standard_parallel: 0,
                                                  scale_factor_pseudo_standard_parallel: 0,
                                                  false_easting: 0, false_northing: 0,
                                                  angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_krovak
    context = Proj::Context.new
    proj = Proj::Projection.krovak(context, latitude_projection_centre: 0, longitude_of_origin: 0,
                                   colatitude_cone_axis: 0, latitude_pseudo_standard_parallel: 0,
                                   scale_factor_pseudo_standard_parallel: 0,
                                   false_easting: 0, false_northing: 0,
                                   angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                   linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_lambert_azimuthal_equal_area
    context = Proj::Context.new
    proj = Proj::Projection.lambert_azimuthal_equal_area(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                                         false_easting: 0, false_northing: 0,
                                                         angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                         linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_miller_cylindrical
    context = Proj::Context.new
    proj = Proj::Projection.miller_cylindrical(context, center_longitude: 0,
                                               false_easting: 0, false_northing: 0,
                                               angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_mercator_variant_a
    context = Proj::Context.new
    proj = Proj::Projection.mercator_variant_a(context, center_latitude: 0, center_longitude: 0,
                                               scale: 1,
                                               false_easting: 0, false_northing: 0,
                                               angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_mercator_variant_b
    context = Proj::Context.new
    proj = Proj::Projection.mercator_variant_b(context, latitude_first_parallel: 0, center_longitude: 0,
                                               false_easting: 0, false_northing: 0,
                                               angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_popular_visualisation_pseudo_mercator
    context = Proj::Context.new
    proj = Proj::Projection.popular_visualisation_pseudo_mercator(context, center_latitude: 0, center_longitude: 0,
                                                                  false_easting: 0, false_northing: 0,
                                                                  angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                                  linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_mollweide
    context = Proj::Context.new
    proj = Proj::Projection.mollweide(context, center_longitude: 0,
                                      false_easting: 0, false_northing: 0,
                                      angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_new_zealand_mapping_grid
    context = Proj::Context.new
    proj = Proj::Projection.new_zealand_mapping_grid(context, center_latitude: 0, center_longitude: 0,
                                                     false_easting: 0, false_northing: 0,
                                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_oblique_stereographic
    context = Proj::Context.new
    proj = Proj::Projection.oblique_stereographic(context, center_latitude: 0, center_longitude: 0,
                                                  scale: 1,
                                                  false_easting: 0, false_northing: 0,
                                                  angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_orthographic
    context = Proj::Context.new
    proj = Proj::Projection.orthographic(context, center_latitude: 0, center_longitude: 0,
                                         false_easting: 0, false_northing: 0,
                                         angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                         linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_american_polyconic
    context = Proj::Context.new
    proj = Proj::Projection.american_polyconic(context, center_latitude: 0, center_longitude: 0,
                                               false_easting: 0, false_northing: 0,
                                               angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_polar_stereographic_variant_a
    context = Proj::Context.new
    proj = Proj::Projection.polar_stereographic_variant_a(context, center_latitude: 0, center_longitude: 0,
                                                          scale: 1,
                                                          false_easting: 0, false_northing: 0,
                                                          angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                          linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_polar_stereographic_variant_b
    context = Proj::Context.new
    proj = Proj::Projection.polar_stereographic_variant_b(context, latitude_standard_parallel: 0, longitude_of_origin: 0,
                                                          false_easting: 0, false_northing: 0,
                                                          angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                          linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_robinson
    context = Proj::Context.new
    proj = Proj::Projection.robinson(context, center_longitude: 0,
                                     false_easting: 0, false_northing: 0,
                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_sinusoidal
    context = Proj::Context.new
    proj = Proj::Projection.sinusoidal(context, center_longitude: 0,
                                       false_easting: 0, false_northing: 0,
                                       angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_stereographic
    context = Proj::Context.new
    proj = Proj::Projection.stereographic(context, center_latitude: 0, center_longitude: 0,
                                          scale: 1,
                                          false_easting: 0, false_northing: 0,
                                          angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                          linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_van_der_grinten
    context = Proj::Context.new
    proj = Proj::Projection.van_der_grinten(context, center_longitude: 0,
                                            false_easting: 0, false_northing: 0,
                                            angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                            linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_wagner_i
    context = Proj::Context.new
    proj = Proj::Projection.wagner_i(context, center_longitude: 0,
                                     false_easting: 0, false_northing: 0,
                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_wagner_ii
    context = Proj::Context.new
    proj = Proj::Projection.wagner_ii(context, center_longitude: 0,
                                      false_easting: 0, false_northing: 0,
                                      angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_wagner_iii
    context = Proj::Context.new
    proj = Proj::Projection.wagner_iii(context, latitude_true_scale: 0,
                                       center_longitude: 0,
                                       false_easting: 0, false_northing: 0,
                                       angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_wagner_iv
    context = Proj::Context.new
    proj = Proj::Projection.wagner_iv(context, center_longitude: 0,
                                      false_easting: 0, false_northing: 0,
                                      angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_wagner_v
    context = Proj::Context.new
    proj = Proj::Projection.wagner_v(context, center_longitude: 0,
                                     false_easting: 0, false_northing: 0,
                                     angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_wagner_vi
    context = Proj::Context.new
    proj = Proj::Projection.wagner_vi(context, center_longitude: 0,
                                      false_easting: 0, false_northing: 0,
                                      angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_wagner_vii
    context = Proj::Context.new
    proj = Proj::Projection.wagner_vii(context, center_longitude: 0,
                                       false_easting: 0, false_northing: 0,
                                       angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_quadrilateralized_spherical_cube
    context = Proj::Context.new
    proj = Proj::Projection.quadrilateralized_spherical_cube(context, center_latitude: 0, center_longitude: 0,
                                                             false_easting: 0, false_northing: 0,
                                                             angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                             linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_spherical_cross_track_height
    context = Proj::Context.new
    proj = Proj::Projection.spherical_cross_track_height(context, peg_point_lat: 0, peg_point_long: 0,
                                                         peg_point_heading: 0, peg_point_height: 0,
                                                         angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                         linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_equal_earth
    context = Proj::Context.new
    proj = Proj::Projection.equal_earth(context, center_longitude: 0,
                                        false_easting: 0, false_northing: 0,
                                        angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                        linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_vertical_perspective
    context = Proj::Context.new
    proj = Proj::Projection.vertical_perspective(context,
                                                 topo_origin_lat: 0, topo_origin_long: 0, topo_origin_height: 0,
                                                 view_point_height: 0,
                                                 false_easting: 0, false_northing: 0,
                                                 angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                 linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)
    assert(proj)
  end

  def test_pole_rotation_grib_convention
    context = Proj::Context.new
    proj = Proj::Projection.pole_rotation_grib_convention(context,
                                                          south_pole_lat_in_unrotated_crs: 0, south_pole_long_in_unrotated_crs: 0,
                                                          axis_rotation: 0,
                                                          angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433)
    assert(proj)
  end

  def test_pole_rotation_netcdf_cf_convention
    context = Proj::Context.new
    proj = Proj::Projection.pole_rotation_netcdf_cf_convention(context,
                                                               grid_north_pole_latitude: 0, grid_north_pole_longitude: 0,
                                                               north_pole_grid_longitude: 0,
                                                               angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433)
    assert(proj)
  end

  if Proj::Api::PROJ_VERSION >= Gem::Version.new('9.5.0')
    def test_local_orthographic
      context = Proj::Context.new
      captured_args = nil
      api_singleton = Proj::Api.singleton_class
      conversion_singleton = Proj::Conversion.singleton_class

      api_singleton.class_eval do
        alias_method :__orig_proj_create_conversion_local_orthographic, :proj_create_conversion_local_orthographic
        define_method(:proj_create_conversion_local_orthographic) do |*args|
          captured_args = args
          FFI::MemoryPointer.new(:char, 1)
        end
      end

      conversion_singleton.class_eval do
        alias_method :__orig_create_object, :create_object
        define_method(:create_object) do |_ptr, _context|
          :ok
        end
      end

      result = Proj::Projection.local_orthographic(context,
                                                   latitude_nat_origin: 11, longitude_nat_origin: 22,
                                                   ellipsoidal_height: 33, geocentric_x_origin: 44,
                                                   geocentric_y_origin: 55, geocentric_z_origin: 66,
                                                   angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433,
                                                   linear_unit_name: "Metre", linear_unit_conversion_factor: 1.0)

      assert_equal(:ok, result)
      assert_equal([context, 11, 22, 33, 44, 55, 66, "Degree", 0.0174532925199433, "Metre", 1.0], captured_args)
    ensure
      conversion_singleton.class_eval do
        remove_method :create_object
        alias_method :create_object, :__orig_create_object
        remove_method :__orig_create_object
      end

      api_singleton.class_eval do
        remove_method :proj_create_conversion_local_orthographic
        alias_method :proj_create_conversion_local_orthographic, :__orig_proj_create_conversion_local_orthographic
        remove_method :__orig_proj_create_conversion_local_orthographic
      end
    end
  end
end
