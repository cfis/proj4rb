# encoding: UTF-8
require 'stringio'

module Proj
  # Projections are coordinate operations that are conversions. For more information about each
  # projection @see https://proj.org/operations/projections/index.html
  module Projection
    # Create a new utm projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param zone [int] UTM Zone
    # @param north [int] Specifies if this is northern or southern hemisphere
    # 
    # @return [Crs]
    def self.utm(context, zone:, north: true)
      ptr = Api.proj_create_conversion_utm(context, zone, north ? 1 : 0)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new transverse_mercator projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.transverse_mercator(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_transverse_mercator(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new gauss_schreiber_transverse_mercator projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.gauss_schreiber_transverse_mercator(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_gauss_schreiber_transverse_mercator(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new transverse_mercator_south_oriented projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.transverse_mercator_south_oriented(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_transverse_mercator_south_oriented(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new two_point_equidistant projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_first_point [Float] 
    # @param longitude_first_point [Float] 
    # @param latitude_second_point [Float] 
    # @param longitude_second_point [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.two_point_equidistant(context, latitude_first_point:, longitude_first_point:, latitude_second_point:, longitude_second_point:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_two_point_equidistant(context, latitude_first_point, longitude_first_point, latitude_second_point, longitude_second_point, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new tunisia_mapping_grid projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.tunisia_mapping_grid(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_tunisia_mapping_grid(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new tunisia_mining_grid projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.tunisia_mining_grid(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_tunisia_mining_grid(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new albers_equal_area projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_false_origin [Float] Latitude of false origin
    # @param longitude_false_origin [Float] Longitude of false origin
    # @param latitude_first_parallel [Float] 
    # @param latitude_second_parallel [Float] 
    # @param easting_false_origin [Float] Easting of false origin
    # @param northing_false_origin [Float] Northing of false origin
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.albers_equal_area(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_albers_equal_area(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new lambert_conic_conformal_1sp projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.lambert_conic_conformal_1sp(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_1sp(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new lambert_conic_conformal_2sp projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_false_origin [Float] Latitude of false origin
    # @param longitude_false_origin [Float] Longitude of false origin
    # @param latitude_first_parallel [Float] 
    # @param latitude_second_parallel [Float] 
    # @param easting_false_origin [Float] Easting of false origin
    # @param northing_false_origin [Float] Northing of false origin
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.lambert_conic_conformal_2sp(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new lambert_conic_conformal_2sp_michigan projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_false_origin [Float] Latitude of false origin
    # @param longitude_false_origin [Float] Longitude of false origin
    # @param latitude_first_parallel [Float] 
    # @param latitude_second_parallel [Float] 
    # @param easting_false_origin [Float] Easting of false origin
    # @param northing_false_origin [Float] Northing of false origin
    # @param ellipsoid_scaling_factor [Float] 
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.lambert_conic_conformal_2sp_michigan(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, ellipsoid_scaling_factor:, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp_michigan(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, ellipsoid_scaling_factor, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new lambert_conic_conformal_2sp_belgium projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_false_origin [Float] Latitude of false origin
    # @param longitude_false_origin [Float] Longitude of false origin
    # @param latitude_first_parallel [Float] 
    # @param latitude_second_parallel [Float] 
    # @param easting_false_origin [Float] Easting of false origin
    # @param northing_false_origin [Float] Northing of false origin
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.lambert_conic_conformal_2sp_belgium(context, latitude_false_origin:, longitude_false_origin:, latitude_first_parallel:, latitude_second_parallel:, easting_false_origin:, northing_false_origin:, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_lambert_conic_conformal_2sp_belgium(context, latitude_false_origin, longitude_false_origin, latitude_first_parallel, latitude_second_parallel, easting_false_origin, northing_false_origin, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new azimuthal_equidistant projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_nat_origin [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.azimuthal_equidistant(context, latitude_nat_origin:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_azimuthal_equidistant(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new guam_projection projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_nat_origin [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.guam_projection(context, latitude_nat_origin:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_guam_projection(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new bonne projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_nat_origin [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.bonne(context, latitude_nat_origin:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_bonne(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new lambert_cylindrical_equal_area_spherical projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_first_parallel [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_lambert_cylindrical_equal_area_spherical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new lambert_cylindrical_equal_area projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_first_parallel [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.lambert_cylindrical_equal_area(context, latitude_first_parallel:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_lambert_cylindrical_equal_area(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new cassini_soldner projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.cassini_soldner(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_cassini_soldner(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new equidistant_conic projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param latitude_first_parallel [Float] 
    # @param latitude_second_parallel [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.equidistant_conic(context, center_latitude:, center_longitude:, latitude_first_parallel:, latitude_second_parallel:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_equidistant_conic(context, center_latitude, center_longitude, latitude_first_parallel, latitude_second_parallel, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new eckert_i projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.eckert_i(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_eckert_i(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new eckert_ii projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.eckert_ii(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_eckert_ii(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new eckert_iii projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.eckert_iii(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_eckert_iii(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new eckert_iv projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.eckert_iv(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_eckert_iv(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new eckert_v projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.eckert_v(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_eckert_v(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new eckert_vi projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.eckert_vi(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_eckert_vi(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new equidistant_cylindrical projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_first_parallel [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.equidistant_cylindrical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_equidistant_cylindrical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new equidistant_cylindrical_spherical projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_first_parallel [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.equidistant_cylindrical_spherical(context, latitude_first_parallel:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_equidistant_cylindrical_spherical(context, latitude_first_parallel, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new gall projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.gall(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_gall(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new goode_homolosine projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.goode_homolosine(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_goode_homolosine(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new interrupted_goode_homolosine projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.interrupted_goode_homolosine(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_interrupted_goode_homolosine(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new geostationary_satellite_sweep_x projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param height [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.geostationary_satellite_sweep_x(context, center_longitude:, height:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_geostationary_satellite_sweep_x(context, center_longitude, height, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new geostationary_satellite_sweep_y projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param height [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.geostationary_satellite_sweep_y(context, center_longitude:, height:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_geostationary_satellite_sweep_y(context, center_longitude, height, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new gnomonic projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.gnomonic(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_gnomonic(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new hotine_oblique_mercator_variant_a projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_projection_centre [Float] Latitude of projection centre
    # @param longitude_projection_centre [Float] Longitude of projection centre
    # @param azimuth_initial_line [Float] Azimuth of initial line
    # @param angle_from_rectified_to_skrew_grid [Float] 
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.hotine_oblique_mercator_variant_a(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, angle_from_rectified_to_skrew_grid:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_hotine_oblique_mercator_variant_a(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, angle_from_rectified_to_skrew_grid, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new hotine_oblique_mercator_variant_b projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_projection_centre [Float] Latitude of projection centre
    # @param longitude_projection_centre [Float] Longitude of projection centre
    # @param azimuth_initial_line [Float] Azimuth of initial line
    # @param angle_from_rectified_to_skrew_grid [Float] 
    # @param scale [Float] Scale Factor. Default is 1.
    # @param easting_projection_centre [Float] Easting at projection centre
    # @param northing_projection_centre [Float] Northing at projection centre
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.hotine_oblique_mercator_variant_b(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, angle_from_rectified_to_skrew_grid:, scale: 1, easting_projection_centre:, northing_projection_centre:, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_hotine_oblique_mercator_variant_b(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, angle_from_rectified_to_skrew_grid, scale, easting_projection_centre, northing_projection_centre, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new hotine_oblique_mercator_two_point_natural_origin projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_projection_centre [Float] Latitude of projection centre
    # @param latitude_point1 [Float] 
    # @param longitude_point1 [Float] 
    # @param latitude_point2 [Float] 
    # @param longitude_point2 [Float] 
    # @param scale [Float] Scale Factor. Default is 1.
    # @param easting_projection_centre [Float] Easting at projection centre
    # @param northing_projection_centre [Float] Northing at projection centre
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre:, latitude_point1:, longitude_point1:, latitude_point2:, longitude_point2:, scale: 1, easting_projection_centre:, northing_projection_centre:, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_hotine_oblique_mercator_two_point_natural_origin(context, latitude_projection_centre, latitude_point1, longitude_point1, latitude_point2, longitude_point2, scale, easting_projection_centre, northing_projection_centre, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new laborde_oblique_mercator projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_projection_centre [Float] Latitude of projection centre
    # @param longitude_projection_centre [Float] Longitude of projection centre
    # @param azimuth_initial_line [Float] Azimuth of initial line
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.laborde_oblique_mercator(context, latitude_projection_centre:, longitude_projection_centre:, azimuth_initial_line:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_laborde_oblique_mercator(context, latitude_projection_centre, longitude_projection_centre, azimuth_initial_line, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new international_map_world_polyconic projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param latitude_first_parallel [Float] 
    # @param latitude_second_parallel [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.international_map_world_polyconic(context, center_longitude:, latitude_first_parallel:, latitude_second_parallel:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_international_map_world_polyconic(context, center_longitude, latitude_first_parallel, latitude_second_parallel, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new krovak_north_oriented projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_projection_centre [Float] Latitude of projection centre
    # @param longitude_of_origin [Float] Longitude of origin
    # @param colatitude_cone_axis [Float] Co-latitude of cone axis
    # @param latitude_pseudo_standard_parallel [Float] Latitude of pseudo standard
    # @param scale_factor_pseudo_standard_parallel [Float] Scale factor on pseudo
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.krovak_north_oriented(context, latitude_projection_centre:, longitude_of_origin:, colatitude_cone_axis:, latitude_pseudo_standard_parallel:, scale_factor_pseudo_standard_parallel:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_krovak_north_oriented(context, latitude_projection_centre, longitude_of_origin, colatitude_cone_axis, latitude_pseudo_standard_parallel, scale_factor_pseudo_standard_parallel, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new krovak projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_projection_centre [Float] Latitude of projection centre
    # @param longitude_of_origin [Float] Longitude of origin
    # @param colatitude_cone_axis [Float] Co-latitude of cone axis
    # @param latitude_pseudo_standard_parallel [Float] Latitude of pseudo standard
    # @param scale_factor_pseudo_standard_parallel [Float] Scale factor on pseudo
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.krovak(context, latitude_projection_centre:, longitude_of_origin:, colatitude_cone_axis:, latitude_pseudo_standard_parallel:, scale_factor_pseudo_standard_parallel:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_krovak(context, latitude_projection_centre, longitude_of_origin, colatitude_cone_axis, latitude_pseudo_standard_parallel, scale_factor_pseudo_standard_parallel, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new lambert_azimuthal_equal_area projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_nat_origin [Float] 
    # @param longitude_nat_origin [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.lambert_azimuthal_equal_area(context, latitude_nat_origin:, longitude_nat_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_lambert_azimuthal_equal_area(context, latitude_nat_origin, longitude_nat_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new miller_cylindrical projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.miller_cylindrical(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_miller_cylindrical(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new mercator_variant_a projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.mercator_variant_a(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_mercator_variant_a(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new mercator_variant_b projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_first_parallel [Float] 
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.mercator_variant_b(context, latitude_first_parallel:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_mercator_variant_b(context, latitude_first_parallel, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new popular_visualisation_pseudo_mercator projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.popular_visualisation_pseudo_mercator(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_popular_visualisation_pseudo_mercator(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new mollweide projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.mollweide(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_mollweide(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new new_zealand_mapping_grid projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.new_zealand_mapping_grid(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_new_zealand_mapping_grid(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new oblique_stereographic projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.oblique_stereographic(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_oblique_stereographic(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new orthographic projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.orthographic(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_orthographic(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new american_polyconic projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.american_polyconic(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_american_polyconic(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new polar_stereographic_variant_a projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.polar_stereographic_variant_a(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_polar_stereographic_variant_a(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new polar_stereographic_variant_b projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_standard_parallel [Float] 
    # @param longitude_of_origin [Float] Longitude of origin
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.polar_stereographic_variant_b(context, latitude_standard_parallel:, longitude_of_origin:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_polar_stereographic_variant_b(context, latitude_standard_parallel, longitude_of_origin, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new robinson projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.robinson(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_robinson(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new sinusoidal projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.sinusoidal(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_sinusoidal(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new stereographic projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param scale [Float] Scale Factor. Default is 1.
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.stereographic(context, center_latitude:, center_longitude:, scale: 1, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_stereographic(context, center_latitude, center_longitude, scale, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new van_der_grinten projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.van_der_grinten(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_van_der_grinten(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new wagner_i projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.wagner_i(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_wagner_i(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new wagner_ii projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.wagner_ii(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_wagner_ii(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new wagner_iii projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param latitude_true_scale [Float] 
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.wagner_iii(context, latitude_true_scale:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_wagner_iii(context, latitude_true_scale, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new wagner_iv projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.wagner_iv(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_wagner_iv(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new wagner_v projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.wagner_v(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_wagner_v(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new wagner_vi projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.wagner_vi(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_wagner_vi(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new wagner_vii projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.wagner_vii(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_wagner_vii(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new quadrilateralized_spherical_cube projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_latitude [Float] Latitude of natural origin/Center Latitude
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.quadrilateralized_spherical_cube(context, center_latitude:, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_quadrilateralized_spherical_cube(context, center_latitude, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new spherical_cross_track_height projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param peg_point_lat [Float] Peg latitude (in degree)
    # @param peg_point_long [Float] Peg longitude (in degree)
    # @param peg_point_heading [Float] Peg heading (in degree)
    # @param peg_point_height [Float] 
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.spherical_cross_track_height(context, peg_point_lat:, peg_point_long:, peg_point_heading:, peg_point_height:, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_spherical_cross_track_height(context, peg_point_lat, peg_point_long, peg_point_heading, peg_point_height, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new equal_earth projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param center_longitude [Float] Longitude of natural origin/Central Meridian
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.equal_earth(context, center_longitude:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_equal_earth(context, center_longitude, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new vertical_perspective projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param topo_origin_lat [Float] 
    # @param topo_origin_long [Float] 
    # @param topo_origin_height [Float] 
    # @param view_point_height [Float] 
    # @param false_easting [Float] False Easting. Default is 0.
    # @param false_northing [Float] False Northing. Default is 0.
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # @param linear_unit_name [String] Name of the linear units. Default is Metre
    # @param linear_unit_conversion_factor [Float] Conversion factor from linear unit to meters. Default is 1.
    # 
    # @return [Crs]
    def self.vertical_perspective(context, topo_origin_lat:, topo_origin_long:, topo_origin_height:, view_point_height:, false_easting: 0, false_northing: 0, angular_unit_name: "Degree", angular_unit_conversion_factor: 0.0174532925199433, linear_unit_name: "Metre", linear_unit_conversion_factor: 1)
      ptr = Api.proj_create_conversion_vertical_perspective(context, topo_origin_lat, topo_origin_long, topo_origin_height, view_point_height, false_easting, false_northing, angular_unit_name, angular_unit_conversion_factor, linear_unit_name, linear_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new pole_rotation_grib_convention projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param south_pole_lat_in_unrotated_crs [Float] 
    # @param south_pole_long_in_unrotated_crs [Float] 
    # @param axis_rotation [Float] 
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # 
    # @return [Crs]
    def self.pole_rotation_grib_convention(context, south_pole_lat_in_unrotated_crs:, south_pole_long_in_unrotated_crs:, axis_rotation:, angular_unit_name: "Degree", angular_unit_conversion_factor:)
      ptr = Api.proj_create_conversion_pole_rotation_grib_convention(context, south_pole_lat_in_unrotated_crs, south_pole_long_in_unrotated_crs, axis_rotation, angular_unit_name, angular_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end

    # Create a new pole_rotation_netcdf_cf_convention projection
    # 
    # @see https://proj.org/operations/projections/index.html
    # 
    # @param context [Context] Proj Context
    # @param grid_north_pole_latitude [Float] 
    # @param grid_north_pole_longitude [Float] 
    # @param north_pole_grid_longitude [Float] 
    # @param angular_unit_name [String] Name of the angular units. Default is Degree.
    # @param angular_unit_conversion_factor [Float] Conversion factor from angular unit to radians. Default is 0.0174532925199433.
    # 
    # @return [Crs]
    def self.pole_rotation_netcdf_cf_convention(context, grid_north_pole_latitude:, grid_north_pole_longitude:, north_pole_grid_longitude:, angular_unit_name: "Degree", angular_unit_conversion_factor:)
      ptr = Api.proj_create_conversion_pole_rotation_netcdf_cf_convention(context, grid_north_pole_latitude, grid_north_pole_longitude, north_pole_grid_longitude, angular_unit_name, angular_unit_conversion_factor)

      if ptr.null?
        Error.check_context(context)
      end

      Conversion.create_object(ptr, context)
    end
  end
end
