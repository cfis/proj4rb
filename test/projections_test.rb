# encoding: UTF-8

require_relative './abstract_test'

class ProjectionsTest < AbstractTest
  def test_utm
    context = Proj::Context.new
    proj = Proj::Conversion.utm(context, zone: 1, north: 0)
    assert(proj)
  end

  def test_transverse_mercator
    context = Proj::Context.new
    proj = Proj::Conversion.transverse_mercator(context, center_lat: 0, center_long: 0,
                                                scale: 0, false_easting: 0, false_northing: 0,
                                                ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_gauss_schreiber_transverse_mercator
    context = Proj::Context.new
    proj = Proj::Conversion.gauss_schreiber_transverse_mercator(context, center_lat: 0, center_long: 0,
                                                                scale: 0, false_easting: 0, false_northing: 0,
                                                                ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                                linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_transverse_mercator_south_oriented
    context = Proj::Context.new
    proj = Proj::Conversion.transverse_mercator_south_oriented(context, center_lat: 0, center_long: 0,
                                                               scale: 0, false_easting: 0, false_northing: 0,
                                                               ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                               linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_two_point_equidistant
    context = Proj::Context.new

    proj = Proj::Conversion.two_point_equidistant(context,
                                                  latitude_first_point: 0, longitude_first_point: 0,
                                                  latitude_second_point: 0, longitude_secon_point: 0,
                                                  false_easting: 0, false_northing: 0,
                                                  ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_tunisia_mining_grid
    context = Proj::Context.new
    proj = Proj::Conversion.tunisia_mining_grid(context, center_lat: 0, center_long: 0,
                                                false_easting: 0, false_northing: 0,
                                                ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_albers_equal_area
    context = Proj::Context.new

    proj = Proj::Conversion.albers_equal_area(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                              latitude_first_parallel: 0, latitude_second_parallel: 0,
                                              easting_false_origin: 0, northing_false_origin: 0,
                                              ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                              linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_lambert_conic_conformal_1sp
    context = Proj::Context.new
    proj = Proj::Conversion.lambert_conic_conformal_1sp(context, center_lat: 0, center_long: 0, scale: 0,
                                                        false_easting: 0, false_northing: 0,
                                                        ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                        linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_lambert_conic_conformal_2sp
    context = Proj::Context.new
    proj = Proj::Conversion.lambert_conic_conformal_2sp(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                                        latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                        easting_false_origin: 0, northing_false_origin: 0,
                                                        ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                        linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_lambert_conic_conformal_2sp_michigan
    context = Proj::Context.new
    proj = Proj::Conversion.lambert_conic_conformal_2sp_michigan(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                                                 latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                                 easting_false_origin: 0, northing_false_origin: 0,
                                                                 ellipsoid_scaling_factor: 0,
                                                                 ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                                 linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_lambert_conic_conformal_2sp_belgium
    context = Proj::Context.new
    proj = Proj::Conversion.lambert_conic_conformal_2sp_belgium(context, latitude_false_origin: 0, longitude_false_origin: 0,
                                                                latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                                easting_false_origin: 0, northing_false_origin: 0,
                                                                ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                                linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_azimuthal_equidistant
    context = Proj::Context.new
    proj = Proj::Conversion.azimuthal_equidistant(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                                  false_easting: 0, false_northing: 0,
                                                  ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)

    assert(proj)
  end

  def test_guam_projection
    context = Proj::Context.new
    proj = Proj::Conversion.guam_projection(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                            false_easting: 0, false_northing: 0,
                                            ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                            linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_bonne
    context = Proj::Context.new
    proj = Proj::Conversion.bonne(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                  false_easting: 0, false_northing: 0,
                                  ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                  linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_lambert_cylindrical_equal_area_spherical
    context = Proj::Context.new
    proj = Proj::Conversion.lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                                     false_easting: 0, false_northing: 0,
                                                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)

    assert(proj)
  end

  def test_lambert_cylindrical_equal_area
    context = Proj::Context.new
    proj = Proj::Conversion.lambert_cylindrical_equal_area(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                           false_easting: 0, false_northing: 0,
                                                           ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                           linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_cassini_soldner
    context = Proj::Context.new
    proj = Proj::Conversion.cassini_soldner(context, center_lat: 0, center_long: 0,
                                            false_easting: 0, false_northing: 0,
                                            ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                            linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_equidistant_conic
    context = Proj::Context.new
    proj = Proj::Conversion.equidistant_conic(context, center_lat: 0, center_long: 0,
                                              latitude_first_parallel: 0, latitude_second_parallel: 0,
                                              false_easting: 0, false_northing: 0,
                                              ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                              linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_eckert_i
    context = Proj::Context.new
    proj = Proj::Conversion.eckert_i(context, center_long: 0,
                                     false_easting: 0, false_northing: 0,
                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_eckert_ii
    context = Proj::Context.new
    proj = Proj::Conversion.eckert_ii(context, center_long: 0,
                                      false_easting: 0, false_northing: 0,
                                      ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_eckert_iii
    context = Proj::Context.new
    proj = Proj::Conversion.eckert_iii(context, center_long: 0,
                                       false_easting: 0, false_northing: 0,
                                       ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_eckert_iv
    context = Proj::Context.new
    proj = Proj::Conversion.eckert_iv(context, center_long: 0,
                                      false_easting: 0, false_northing: 0,
                                      ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_eckert_v
    context = Proj::Context.new
    proj = Proj::Conversion.eckert_v(context, center_long: 0,
                                     false_easting: 0, false_northing: 0,
                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_eckert_vi
    context = Proj::Context.new
    proj = Proj::Conversion.eckert_vi(context, center_long: 0,
                                      false_easting: 0, false_northing: 0,
                                      ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_equidistant_cylindrical
    context = Proj::Context.new
    proj = Proj::Conversion.equidistant_cylindrical(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                    false_easting: 0, false_northing: 0,
                                                    ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                    linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_equidistant_cylindrical_spherical
    context = Proj::Context.new
    proj = Proj::Conversion.equidistant_cylindrical_spherical(context, latitude_first_parallel: 0, longitude_nat_origin: 0,
                                                              false_easting: 0, false_northing: 0,
                                                              ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_gall
    context = Proj::Context.new
    proj = Proj::Conversion.gall(context, center_long: 0,
                                 false_easting: 0, false_northing: 0,
                                 ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                 linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_goode_homolosine
    context = Proj::Context.new
    proj = Proj::Conversion.goode_homolosine(context, center_long: 0,
                                             false_easting: 0, false_northing: 0,
                                             ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                             linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_interrupted_goode_homolosine
    context = Proj::Context.new
    proj = Proj::Conversion.interrupted_goode_homolosine(context, center_long: 0,
                                                         false_easting: 0, false_northing: 0,
                                                         ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                         linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_geostationary_satellite_sweep_x
    context = Proj::Context.new
    proj = Proj::Conversion.geostationary_satellite_sweep_x(context, center_long: 0, height: 0,
                                                            false_easting: 0, false_northing: 0,
                                                            ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                            linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_geostationary_satellite_sweep_y
    context = Proj::Context.new
    proj = Proj::Conversion.geostationary_satellite_sweep_y(context, center_long: 0, height: 0,
                                                            false_easting: 0, false_northing: 0,
                                                            ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                            linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_gnomonic
    context = Proj::Context.new
    proj = Proj::Conversion.gnomonic(context, center_lat: 0, center_long: 0,
                                     false_easting: 0, false_northing: 0,
                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_hotine_oblique_mercator_variant_a
    context = Proj::Context.new
    proj = Proj::Conversion.hotine_oblique_mercator_variant_a(context,
                                                              latitude_projection_centre: 0, longitude_projection_centre: 0,
                                                              azimuth_initial_line: 0, angle_from_rectified_to_skrew_grid: 0,
                                                              scale: 0,
                                                              false_easting: 0, false_northing: 0,
                                                              ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_hotine_oblique_mercator_variant_b
    context = Proj::Context.new
    proj = Proj::Conversion.hotine_oblique_mercator_variant_b(context,
                                                              latitude_projection_centre: 0, longitude_projection_centre: 0,
                                                              azimuth_initial_line: 0, angle_from_rectified_to_skrew_grid: 0,
                                                              scale: 0,
                                                              easting_projection_centre: 0,  northing_projection_centre: 0,
                                                              ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_hotine_oblique_mercator_two_point_natural_origin
    context = Proj::Context.new
    proj = Proj::Conversion.hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre: 0,
                                                                             latitude_point1: 0, longitude_point1: 0,
                                                                             latitude_point2: 0, longitude_point2: 0,
                                                                             scale: 0,
                                                                             easting_projection_centre: 0, northing_projection_centre: 0,
                                                                             ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                                             linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_laborde_oblique_mercator
    context = Proj::Context.new
    proj = Proj::Conversion.laborde_oblique_mercator(context, latitude_projection_centre: 0, longitude_projection_centre: 0,
                                                     azimuth_initial_line: 0,
                                                     scale: 0,
                                                     false_easting: 0, false_northing: 0,
                                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_international_map_world_polyconic
    context = Proj::Context.new
    proj = Proj::Conversion.international_map_world_polyconic(context, center_long: 0,
                                                              latitude_first_parallel: 0, latitude_second_parallel: 0,
                                                              false_easting: 0, false_northing: 0,
                                                              ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                              linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_krovak_north_oriented
    context = Proj::Context.new
    proj = Proj::Conversion.krovak_north_oriented(context, latitude_projection_centre: 0, longitude_of_origin: 0,
                                                  colatitude_cone_axis: 0, latitude_pseudo_standard_parallel: 0,
                                                  scale_factor_pseudo_standard_parallel: 0,
                                                  false_easting: 0, false_northing: 0,
                                                  ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_krovak
    context = Proj::Context.new
    proj = Proj::Conversion.krovak(context, latitude_projection_centre: 0, longitude_of_origin: 0,
                                   colatitude_cone_axis: 0, latitude_pseudo_standard_parallel: 0,
                                   scale_factor_pseudo_standard_parallel: 0,
                                   false_easting: 0, false_northing: 0,
                                   ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                   linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_lambert_azimuthal_equal_area
    context = Proj::Context.new
    proj = Proj::Conversion.lambert_azimuthal_equal_area(context, latitude_nat_origin: 0, longitude_nat_origin: 0,
                                                         false_easting: 0, false_northing: 0,
                                                         ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                         linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_miller_cylindrical
    context = Proj::Context.new
    proj = Proj::Conversion.miller_cylindrical(context, center_long: 0,
                                               false_easting: 0, false_northing: 0,
                                               ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_mercator_variant_a
    context = Proj::Context.new
    proj = Proj::Conversion.mercator_variant_a(context, center_lat:0, center_long: 0,
                                               scale: 0,
                                               false_easting: 0, false_northing: 0,
                                               ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_mercator_variant_b
    context = Proj::Context.new
    proj = Proj::Conversion.mercator_variant_b(context, latitude_first_parallel:0, center_long: 0,
                                               false_easting: 0, false_northing: 0,
                                               ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_popular_visualisation_pseudo_mercator
    context = Proj::Context.new
    proj = Proj::Conversion.popular_visualisation_pseudo_mercator(context, center_lat:0, center_long: 0,
                                                                  false_easting: 0, false_northing: 0,
                                                                  ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                                  linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_mollweide
    context = Proj::Context.new
    proj = Proj::Conversion.mollweide(context, center_long: 0,
                                      false_easting: 0, false_northing: 0,
                                      ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_new_zealand_mapping_grid
    context = Proj::Context.new
    proj = Proj::Conversion.new_zealand_mapping_grid(context, center_lat:0, center_long: 0,
                                                     false_easting: 0, false_northing: 0,
                                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_oblique_stereographic
    context = Proj::Context.new
    proj = Proj::Conversion.oblique_stereographic(context, center_lat:0, center_long: 0,
                                                  scale: 0,
                                                  false_easting: 0, false_northing: 0,
                                                  ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                  linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_orthographic
    context = Proj::Context.new
    proj = Proj::Conversion.orthographic(context, center_lat: 0, center_long: 0,
                                         false_easting: 0, false_northing: 0,
                                         ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                         linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_american_polyconic
    context = Proj::Context.new
    proj = Proj::Conversion.american_polyconic(context, center_lat: 0, center_long: 0,
                                               false_easting: 0, false_northing: 0,
                                               ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                               linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_polar_stereographic_variant_a
    context = Proj::Context.new
    proj = Proj::Conversion.polar_stereographic_variant_a(context, center_lat: 0, center_long: 0,
                                                          scale: 0,
                                                          false_easting: 0, false_northing: 0,
                                                          ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                          linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_polar_stereographic_variant_b
    context = Proj::Context.new
    proj = Proj::Conversion.polar_stereographic_variant_b(context, latitude_standard_parallel: 0, longitude_of_origin: 0,
                                                          false_easting: 0, false_northing: 0,
                                                          ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                          linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_robinson
    context = Proj::Context.new
    proj = Proj::Conversion.robinson(context, center_long: 0,
                                     false_easting: 0, false_northing: 0,
                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_sinusoidal
    context = Proj::Context.new
    proj = Proj::Conversion.sinusoidal(context, center_long: 0,
                                       false_easting: 0, false_northing: 0,
                                       ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_stereographic
    context = Proj::Context.new
    proj = Proj::Conversion.stereographic(context, center_lat:0, center_long: 0,
                                          scale: 0,
                                          false_easting: 0, false_northing: 0,
                                          ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                          linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_van_der_grinten
    context = Proj::Context.new
    proj = Proj::Conversion.van_der_grinten(context, center_long: 0,
                                            false_easting: 0, false_northing: 0,
                                            ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                            linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_wagner_i
    context = Proj::Context.new
    proj = Proj::Conversion.wagner_i(context, center_long: 0,
                                     false_easting: 0, false_northing: 0,
                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_wagner_ii
    context = Proj::Context.new
    proj = Proj::Conversion.wagner_ii(context, center_long: 0,
                                      false_easting: 0, false_northing: 0,
                                      ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_wagner_iii
    context = Proj::Context.new
    proj = Proj::Conversion.wagner_iii(context, latitude_true_scale: 0,
                                       center_long: 0,
                                       false_easting: 0, false_northing: 0,
                                       ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_wagner_iv
    context = Proj::Context.new
    proj = Proj::Conversion.wagner_iv(context, center_long: 0,
                                      false_easting: 0, false_northing: 0,
                                      ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_wagner_v
    context = Proj::Context.new
    proj = Proj::Conversion.wagner_v(context, center_long: 0,
                                     false_easting: 0, false_northing: 0,
                                     ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                     linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_wagner_vi
    context = Proj::Context.new
    proj = Proj::Conversion.wagner_vi(context, center_long: 0,
                                      false_easting: 0, false_northing: 0,
                                      ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                      linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_wagner_vii
    context = Proj::Context.new
    proj = Proj::Conversion.wagner_vii(context, center_long: 0,
                                       false_easting: 0, false_northing: 0,
                                       ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                       linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_quadrilateralized_spherical_cube
    context = Proj::Context.new
    proj = Proj::Conversion.quadrilateralized_spherical_cube(context, center_lat:0, center_long: 0,
                                                             false_easting: 0, false_northing: 0,
                                                             ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                             linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_spherical_cross_track_height
    context = Proj::Context.new
    proj = Proj::Conversion.spherical_cross_track_height(context, peg_point_lat: 0, peg_point_long: 0,
                                                         peg_point_heading: 0, peg_point_height: 0,
                                                         ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                         linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_equal_earth
    context = Proj::Context.new
    proj = Proj::Conversion.equal_earth(context, center_long: 0,
                                        false_easting: 0, false_northing: 0,
                                        ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                        linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_vertical_perspective
    context = Proj::Context.new
    proj = Proj::Conversion.vertical_perspective(context,
                                                 topo_origin_lat: 0, topo_origin_long: 0, topo_origin_height: 0,
                                                 view_point_height: 0,
                                                 false_easting: 0, false_northing: 0,
                                                 ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433,
                                                 linear_unit_name: "Metre", linear_unit_conv_factor: 1.0)
    assert(proj)
  end

  def test_pole_rotation_grib_convention
    context = Proj::Context.new
    proj = Proj::Conversion.pole_rotation_grib_convention(context,
                                                          south_pole_lat_in_unrotated_crs: 0, south_pole_long_in_unrotated_crs: 0,
                                                          axis_rotation: 0,
                                                          ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433)
    assert(proj)
  end

  def test_pole_rotation_netcdf_cf_convention
    context = Proj::Context.new
    proj = Proj::Conversion.pole_rotation_netcdf_cf_convention(context,
                                                               grid_north_pole_latitude: 0, grid_north_pole_longitude: 0,
                                                               north_pole_grid_longitude: 0,
                                                               ang_unit_name: "Degree", ang_unit_conv_factor: 0.0174532925199433)
    assert(proj)
  end
end
