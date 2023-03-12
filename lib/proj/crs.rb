# encoding: UTF-8
require 'stringio'

module Proj
  # Represents a coordinate reference system.
  class Crs < PjObject
    # To create a coordinate system, you can use CRS codes, well-known text (WKT) strings
    # or old-style Proj4 strings (which are deprecated).
    #
    # @example
    #   crs1 = Proj::Crs.new('EPSG:4326')
    #   crs2 = Proj::Crs.new('urn:ogc:def:crs:EPSG::4326')
    #   crs3 = Proj::Crs.new('+proj=longlat +datum=WGS84 +no_defs +type=crs')
    #   crs4 = Proj::Crs.new(<<~EOS)
    #            GEOGCRS["WGS 84",
    #            DATUM["World Geodetic System 1984",
    #                  ELLIPSOID["WGS 84",6378137,298.257223563,
    #                            LENGTHUNIT["metre",1]]],
    #            PRIMEM["Greenwich",0,
    #                   ANGLEUNIT["degree",0.0174532925199433]],
    #            CS[ellipsoidal,2],
    #            AXIS["geodetic latitude (Lat)",north,
    #                 ORDER[1],
    #                 ANGLEUNIT["degree",0.0174532925199433]],
    #            AXIS["geodetic longitude (Lon)",east,
    #                 ORDER[2],
    #                 ANGLEUNIT["degree",0.0174532925199433]],
    #            USAGE[
    #                SCOPE["unknown"],
    #                    AREA["World"],
    #                BBOX[-90,-180,90,180]],
    #            ID["EPSG",4326]]
    #          EOS
    #
    # Notice when using the old-style Proj4 string, the addition of the "+type=crs" value.
    #
    # @param value [String]. See above
    # @param context [Context]. An optional Context that the Crs will use for calculations.
    def initialize(value, context=nil)
      pointer = Api.proj_create(context || Context.current, value)

      if pointer.null?
        Error.check_object(self)
      end

      super(pointer, context)

      if Api.method_defined?(:proj_is_crs) && !Api.proj_is_crs(pointer)
        raise(Error, "Invalid crs definition. Proj created an instance of: #{self.proj_type}.")
      end
    end

    # Get the geodeticCRS / geographicCRS from a CRS.
    #
    # @example
    #     crs = Proj::Crs.new('EPSG:4326')
    #     geodetic = crs.geodetic_crs
    #     assert_equal(:PJ_TYPE_GEOGRAPHIC_2D_CRS, geodetic.proj_type)
    #     assert_equal('+proj=longlat +datum=WGS84 +no_defs +type=crs', geodetic.to_proj_string)
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_geodetic_crs
    #
    # @return [Crs]
    def geodetic_crs
      ptr = Api.proj_crs_get_geodetic_crs(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Get a CRS component from a CompoundCRS.
    #
    # @see {https://proj.org/development/reference/functions.html#c.proj_crs_get_sub_crs} proj_crs_get_sub_crs
    #
    # @param index [Integer] Index of the CRS component (typically 0 = horizontal, 1 = vertical)
    #
    # @return [Crs]
    def sub_crs(index)
      ptr = Api.proj_crs_get_sub_crs(self.context, self, index)
      PjObject.create_object(ptr, self.context)
    end

    # Returns the datum of a SingleCRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum
    #
    # @return [Datum]
    def datum
      ptr = Api.proj_crs_get_datum(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Returns a datum for a SingleCRS. If the SingleCRS has a datum, then this datum is returned.
    # Otherwise, the SingleCRS has a datum ensemble, and this datum ensemble is returned as
    # a regular datum instead of a datum ensemble.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum_forced
    #
    # @return [Datum]
    def datum_forced
      ptr = Api.proj_crs_get_datum_forced(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Get the horizontal datum from a CRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_horizontal_datum
    #
    # @return [Crs]
    def horizontal_datum
      ptr = Api.proj_crs_get_horizontal_datum(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Returns the {DatumEnsemble datum ensemble} of a SingleCRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum_ensemble
    #
    # @return [DatumEnsemble]
    def datum_ensemble
      ptr = Api.proj_crs_get_datum_ensemble(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Returns the coordinate system of a SingleCRS.
    #
    # @return [CoordinateSystem]
    def coordinate_system
      ptr = Api.proj_crs_get_coordinate_system(self.context, self)
      CoordinateSystem.new(ptr, self.context)
    end

    # Returns the ellipsoid
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_ellipsoid
    #
    # @return [PjObject]
    def ellipsoid
      ptr = Api.proj_get_ellipsoid(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Returns whether a CRS is a derived CRS.
    #
    # @return [Boolean]
    def derived?
      result = Api.proj_crs_is_derived(self.context, self)
      result == 1 ? true : false
    end

    # Return the Conversion of a DerivedCRS (such as a ProjectedCRS), or the Transformation from
    # the baseCRS to the hubCRS of a BoundCRS.
    #
    # @return [PjObject]
    def coordinate_operation
      pointer = Api.proj_crs_get_coordoperation(self.context, self)
      if pointer.null?
        Error.check_object(self)
      end
      PjObject.create_object(pointer, self.context)
    end

    # Returns the prime meridian
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_prime_meridian
    #
    # @return [PjObject]
    def prime_meridian
      ptr = Api.proj_get_prime_meridian(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Returns a list of matching reference CRS, and the percentage (0-100) of confidence in the match.
    #
    # @param auth_name [string] - Authority name, or nil for all authorities
    #
    # @return [Array] - Array of CRS objects sorted by decreasing confidence.
    def identify(auth_name)
      confidences_out_ptr = FFI::MemoryPointer.new(:pointer)
      ptr = Api.proj_identify(self.context, self, auth_name, nil, confidences_out_ptr)
      objects = PjObjects.new(ptr, self.context)

      # Get confidences and free the list
      confidences_ptr = confidences_out_ptr.read_pointer
      confidences = confidences_ptr.read_array_of_type(:int, :read_int, objects.count)
      Api.proj_int_list_destroy(confidences_ptr)

      return objects, confidences
    end

    # Experimental API
    def derived?
      result = Api.proj_is_derived_crs(self.context, crs)
      result == 1 ? true : false
    end

    def alter_name(name)
      ptr = Api.proj_alter_name(self.context, self, name)
      self.create_object(ptr, self.context)
    end

    def alter_id(auth_name, code)
      ptr = Api.proj_alter_id(self.context, self, auth_name, code)
      self.create_object(ptr, self.context)
    end

    def alter_geodetic_crs(new_geod_crs)
      ptr = Api.proj_crs_alter_geodetic_crs(self.context, self, new_geod_crs)
      self.create_object(ptr, self.context)
    end

    def alter_cs_angular_unit(angular_units:, angular_units_conv:, unit_auth_name:, unit_code:)
      ptr = Api.proj_crs_alter_cs_angular_unit(self.context, self, angular_units, angular_units_conv, unit_auth_name, unit_code)
      self.create_object(ptr, self.context)
    end

    def alter_cs_linear_unit(linear_units:, linear_units_conv:, unit_auth_name:, unit_code:)
      ptr = Api.proj_crs_alter_cs_linear_unit(self.context, self, linear_units, linear_units_conv, unit_auth_name, unit_code)
      self.create_object(ptr, self.context)
    end

    def alter_parameters_linear_unit(linear_units:, linear_units_conv:, unit_auth_name:, unit_code:, convert_to_new_unit:)
      ptr = Api.proj_crs_alter_parameters_linear_unit(self.context, self, linear_units, linear_units_conv, unit_auth_name, unit_code, convert_to_new_unit)
      self.create_object(ptr, self.context)
    end

    def promote_to_3d(crs_3d_name:, crs_2d:)
      ptr = Api.proj_crs_promote_to_3D(self.context, crs_3d_name, crs_2d)
      self.create_object(ptr, self.context)
    end

    def projected_3d_crs_from_2d(crs_name:, projected_2d_crs:, geog_3d_crs:)
      ptr = Api.proj_crs_create_projected_3D_crs_from_2D(self.context, crs_name, projected_2d_crs, geog_3d_crs)
      self.create_object(ptr, self.context)
    end

    def demote_to_2d(crs_2d_name:, crs_3d:)
      ptr = Api.proj_crs_demote_to_2D(self.context, crs_2d_name, crs_3d)
      self.create_object(ptr, self.context)
    end

    # Experimental CRS creation methods
    def self.create_projected_crs(context, crs_name:, geodetic_crs:, conversion:, coordinate_system:)
      ptr = Api.proj_create_projected_crs(context, crs_name, geodetic_crs, conversion, coordinate_system)
      self.create_object(ptr, context)
    end

    def self.create_bound_crs(context, base_crs:, hub_crs:, transformation:)
      ptr = Api.proj_crs_create_bound_crs(context, base_crs, hub_crs, transformation)
      self.create_object(ptr, context)
    end

    def self.create_bound_crs_to_WGS84(context, crs:, options:)
      ptr = Api.proj_crs_create_bound_crs_to_WGS84(context, crs, options)
      self.create_object(ptr, context)
    end

    def self.geodetic_crs_from_datum(context, auth_name:, datum_auth_name:, datum_code:, crs_type:)
      ptr = Api.proj_query_geodetic_crs_from_datum(context, auth_name, datum_auth_name, datum_code, crs_type)
      self.create_object(ptr, context)
    end

    def self.create_bound_vertical(context, vert_crs:, hub_geographic_3D_crs:, grid_name:)
      ptr = Api.proj_crs_create_bound_vertical_crs(context, vert_crs, hub_geographic_3D_crs, grid_name)
      self.create_object(ptr, context)
    end

    def self.create_engineering(context, name:)
      ptr = Api.proj_create_engineering_crs(context, name)
      self.create_object(ptr, context)
    end

    def self.create_vertical(context, name:, datum_name:, linear_units:, linear_units_conv:)
      ptr = Api.proj_create_vertical_crs(context, name, datum_name, linear_units, linear_units_conv)
      self.create_object(ptr, context)
    end

    def self.create_vertical_ex(context, name:, datum_name:, datum_auth_name:, datum_code:, linear_units:, linear_units_conv:, geoid_model_name:, geoid_model_auth_name:, geoid_model_code:, geoid_geog_crs:, options:)
      ptr = Api.proj_create_vertical_crs_ex(context, name, datum_name, datum_auth_name, datum_code, linear_units, linear_units_conv, geoid_model_name, geoid_model_auth_name, geoid_model_code, geoid_geog_crs, options)
      self.create_object(ptr, context)
    end

    def self.create_compound(context, name:, horiz_crs:, vert_crs:)
      ptr = Api.proj_create_compound_crs(context, name, horiz_crs, vert_crs)
      self.create_object(ptr, context)
    end

    def self.create_geographic(context, name:, datum_name:, ellps_name:, semi_major_metre:, inv_flattening:, prime_meridian_name:, prime_meridian_offset:, pm_angular_units:, pm_units_conv:, ellipsoidal_cs:)
      ptr = Api.proj_create_geographic_crs(context, name, datum_name, ellps_name, semi_major_metre, inv_flattening, prime_meridian_name, prime_meridian_offset, pm_angular_units, pm_units_conv, ellipsoidal_cs)
      self.create_object(ptr, context)
    end

    def self.create_geographic_from_datum(context, name:, datum_or_datum_ensemble:, ellipsoidal_cs:)
      ptr = Api.proj_create_geographic_crs_from_datum(context, name, datum_or_datum_ensemble, ellipsoidal_cs)
      self.create_object(ptr, context)
    end

    def self.create_geocentric(context, name:, datum_name:, ellps_name:, semi_major_metre:, inv_flattening:, prime_meridian_name:, prime_meridian_offset:, angular_units:, angular_units_conv:, linear_units:, linear_units_conv:)
      ptr = Api.proj_create_geocentric_crs(context, name, datum_name, ellps_name, semi_major_metre, inv_flattening, prime_meridian_name, prime_meridian_offset, angular_units, angular_units_conv, linear_units, linear_units_conv)
      self.create_object(ptr, context)
    end

    def self.create_geocentric_from_datum(context, name:, datum_or_datum_ensemble:, linear_units:, linear_units_conv:)
      ptr = Api.proj_create_geocentric_crs_from_datum(context, name, datum_or_datum_ensemble, linear_units, linear_units_conv)
      self.create_object(ptr, context)
    end

    def self.create_derived_geographic(context, name:, base_geographic_crs:, conversion:, ellipsoidal_cs:)
      ptr = Api.proj_create_derived_geographic_crs(context, name, base_geographic_crs, conversion, ellipsoidal_cs)
      self.create_object(ptr, context)
    end
  end
end
