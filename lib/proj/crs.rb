# encoding: UTF-8
require 'stringio'

module Proj
  # Represents a coordinate reference system.
  class Crs < PjObject
    # Create a ProjectedCRS.
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param geodetic_crs [Crs] Base GeodeticCRS
    # @param conversion [Conversion] Conversion
    # @param coordinate_system [CoordinateSystem] Cartesian coordinate system
    #
    # @return [Crs]
    def self.create_projected(context, name: nil, geodetic_crs:, conversion:, coordinate_system:)
      pointer = Api.proj_create_projected_crs(context, name, geodetic_crs, conversion, coordinate_system)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Returns a BoundCRS
    #
    # @param context [Context] Context
    # @param base_crs [Crs] Base CRS
    # @param hub_crs [Crs] HUB CRS
    # @param transformation [Transformation]
    #
    # @return [Crs]
    def self.create_bound(context, base_crs:, hub_crs:, transformation:)
      pointer = Api.proj_crs_create_bound_crs(context, base_crs, hub_crs, transformation)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Returns a BoundCRS with a transformation to EPSG:4326 wrapping it
    #
    # @param context [Context] Context
    # @param crs [Crs] CRS to wrap
    # @param allow_intermediate_crs [String] Specifies if an intermediate CRS may be considered when
    #        computing the possible transformations. Allowed values are:
    #  * ALWAYS
    #  * IF_NO_DIRECT_TRANSFORMATION
    #  * NEVER
    #
    #  Default is NEVER
    #
    # @return [Crs]
    def self.create_bound_to_wgs84(context, crs:, allow_intermediate_crs: "NEVER")
      options = {"ALLOW_INTERMEDIATE_CRS": allow_intermediate_crs}
      options_ptr = create_options_pointer(options)

      pointer = Api.proj_crs_create_bound_crs_to_WGS84(context, crs, options_ptr)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a a EngineeringCRS
    #
    # @param context [Context] Context
    # @param name [String] Name of the CRS. Default is nil.
    #
    # @return [Crs]
    def self.create_engineering(context, name:)
      pointer = Api.proj_create_engineering_crs(context, name)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a VerticalCRS. For additional functionality see Crs#create_vertical_ex
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param datum_name [String] Name of the GeodeticReferenceFrame. Default is nil.
    # @param linear_units [String] Name of the angular units. Or nil for meters.
    # @param linear_units_conv [Float] Conversion factor from linear units to meters. Default is 0 if linear_units is nil
    #
    # @return [Crs]
    def self.create_vertical(context, name:, datum_name:, linear_units:, linear_units_conv:)
      pointer = Api.proj_create_vertical_crs(context, name, datum_name, linear_units, linear_units_conv)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a Bound Vertical CRS, with a transformation to a hub geographic 3D crs, such as
    # EPSG:4979 or WGS84, using a grid
    #
    # @param context [Context] Context
    # @param vertical_crs [Crs] A VerticalCRS
    # @param hub_crs [Crs] A Geographic 3D CRS
    # @param grid_name [String] Grid name (typically a .gtx file)
    #
    # @return [Crs]
    def self.create_bound_vertical(context, vertical_crs:, hub_crs:, grid_name:)
      pointer = Api.proj_crs_create_bound_vertical_crs(context, vertical_crs, hub_crs, grid_name)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a VerticalCRS. This is an extended version of Crs#create_vertical that adds
    # the capability of defining a geoid model.
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param datum_name [String] Name of the GeodeticReferenceFrame. Default is nil.
    # @param datum_auth_name [String] Authority name of the VerticalReferenceFrame. Default is nil.
    # @param datum_code [String] Code of the VerticalReferenceFrame. Default is nil.
    # @param linear_units [String] Name of the angular units. Or nil for meters.
    # @param linear_units_conv [Float] Conversion factor from linear units to meters. Default is 0 if linear_units is nil
    # @param geoid_model_name [String] Geoid model name. Can be a name from the geoid_model name or a string "PROJ foo.gtx". Default is nil.
    # @param geoid_model_auth_name [String] Authority name of the transformation for the geoid model. Default is nil.
    # @param geoid_model_code [String] Code of the transformation for the geoid model. Default is nil.
    # @param geoid_geog_crs [Crs] Geographic CRS for the geoid transformation. Default is nil.
    # @param accuracy [Float] Accuracy in meters. Default is nil
    #
    # @return [Crs]
    def self.create_vertical_ex(context, name: nil, datum_name: nil, datum_auth_name: nil, datum_code: nil,
                                linear_units: nil, linear_units_conv: 0,
                                geoid_model_name: nil, geoid_model_auth_name: nil, geoid_model_code: nil,
                                geoid_geog_crs: nil, accuracy: nil)

      options = {"ACCURACY": accuracy.nil? ? nil : accuracy.to_s}
      options_ptr = create_options_pointer(options)

      pointer = Api.proj_create_vertical_crs_ex(context, name, datum_name, datum_auth_name, datum_code, linear_units, linear_units_conv, geoid_model_name, geoid_model_auth_name, geoid_model_code, geoid_geog_crs, options_ptr)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a CompoundCRS.
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param horizontal_crs [Crs] A horizontal CRS
    # @param vertical_crs [Crs] A vertical CRS
    #
    # @return [Crs]
    def self.create_compound(context, name:, horizontal_crs:, vertical_crs:)
      pointer = Api.proj_create_compound_crs(context, name, horizontal_crs, vertical_crs)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a GeographicCRS.
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param datum_name [String] Name of the GeodeticReferenceFrame. Default is nil.
    # @param ellipsoid_name [String] Name of the Ellipsoid. Default is nil.
    # @param semi_major_meter [Float] Ellipsoid semi-major axis, in meters.
    # @param inv_flattening [Float] Ellipsoid inverse flattening. Or 0 for a sphere.
    # @param prime_meridian_name [String] Name of the PrimeMeridian. Default is nil.
    # @param prime_meridian_offset [Float] Offset of the prime meridian, expressed in the specified angular units.
    # @param pm_angular_units [String] Name of the angular units. Or nil for degrees.
    # @param pm_angular_units_conv [Float] Conversion factor from the angular unit to radians. Default is 0 if pm_angular_units is nil
    # @param coordinate_system [CoordinateSystem] Ellipsoidal coordinate system
    #
    # @return [Crs]
    def self.create_geographic(context, name:, datum_name:, ellipsoid_name:, semi_major_meter:, inv_flattening:, prime_meridian_name:, prime_meridian_offset:, pm_angular_units:, pm_angular_units_conv:, coordinate_system:)
      pointer = Api.proj_create_geographic_crs(context, name, datum_name, ellipsoid_name, semi_major_meter, inv_flattening, prime_meridian_name, prime_meridian_offset, pm_angular_units, pm_angular_units_conv, coordinate_system)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a GeographicCRS from a datum
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param datum [Datum, DatumEnsemble] Datum or DatumEnsemble
    # @param coordinate_system [CoordinateSystem] Ellipsoidal coordinate system
    #
    # @return [Crs]
    def self.create_geographic_from_datum(context, name:, datum:, coordinate_system:)
      pointer = Api.proj_create_geographic_crs_from_datum(context, name, datum, coordinate_system)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a GeographicCRS.
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param datum_name [String] Name of the GeodeticReferenceFrame. Default is nil.
    # @param ellipsoid_name [String] Name of the Ellipsoid. Default is nil.
    # @param semi_major_meter [Float] Ellipsoid semi-major axis, in meters.
    # @param inv_flattening [Float] Ellipsoid inverse flattening. Or 0 for a sphere.
    # @param prime_meridian_name [String] Name of the PrimeMeridian. Default is nil.
    # @param prime_meridian_offset [Float] Offset of the prime meridian, expressed in the specified angular units.
    # @param angular_units [String] Name of the angular units. Or nil for degrees.
    # @param angular_units_conv [Float] Conversion factor from the angular unit to radians. Default is 0 if angular_units is nil
    # @param linear_units [String] Name of the angular units. Or nil for meters.
    # @param linear_units_conv [Float] Conversion factor from linear units to meters. Default is 0 if linear_units is nil
    #
    # @return [Crs]
    def self.create_geocentric(context, name:, datum_name:, ellipsoid_name:, semi_major_meter:, inv_flattening:, prime_meridian_name:, prime_meridian_offset:, angular_units:, angular_units_conv:, linear_units:, linear_units_conv:)
      pointer = Api.proj_create_geocentric_crs(context, name, datum_name, ellipsoid_name, semi_major_meter, inv_flattening, prime_meridian_name, prime_meridian_offset, angular_units, angular_units_conv, linear_units, linear_units_conv)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a GeodeticCRS of geocentric type
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param datum [Datum, DatumEnsemble] Datum or DatumEnsemble
    # @param linear_units [String] Name of the angular units. Or nil for meters.
    # @param linear_units_conv [Float] Conversion factor from linear units to meters. Default is 0 if linear_units is nil
    #
    # @return [Crs]
    def self.create_geocentric_from_datum(context, name:, datum:, linear_units:, linear_units_conv:)
      pointer = Api.proj_create_geocentric_crs_from_datum(context, name, datum, linear_units, linear_units_conv)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Create a DerivedGeograhicCRS
    #
    # @param context [Context] Context
    # @param name [String] Name of the GeographicCRS. Default is nil.
    # @param base_geographic_crs [Crs] Base Geographic CRS
    # @param conversion [Conversion] Conversion from the base Geographic to the DerivedGeograhicCRS
    # @param coordinate_system [CoordinateSystem] Ellipsoidal coordinate system
    #
    # @return [Crs]
    def self.create_derived_geographic(context, name: nil, base_geographic_crs:, conversion:, coordinate_system:)
      pointer = Api.proj_create_derived_geographic_crs(context, name, base_geographic_crs, conversion, coordinate_system)

      if pointer.null?
        Error.check_context(context)
      end

      self.create_object(pointer, context)
    end

    # Find GeodeticCRSes that use the specified datum
    #
    # @param context [Context] Context
    # @param auth_name [String] - Authority name. Default is nil.
    # @param datum_auth_name [String] Datum authority name
    # @param datum_code [String] Datum code
    # @param crs_type [String] The CRS type. Default is nil. Allowed values are:
    #  * geographic 2D
    #  * geographic 3D
    #  * geocentric
    #
    # @return [PjObjects] - A list of CRSes
    def self.query_geodetic_from_datum(context, auth_name: nil, datum_auth_name:, datum_code:, crs_type: nil)
      pointer = Api.proj_query_geodetic_crs_from_datum(context, auth_name, datum_auth_name, datum_code, crs_type)

      if pointer.null?
        Error.check_context(context)
      end

      PjObjects.new(pointer, context)
    end

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
    #                            LENGTHUNIT["meter",1]]],
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
      ptr = Api.proj_create(context || Context.current, value)

      if ptr.null?
        Error.check_object(self)
      end

      super(ptr, context)

      if Api.method_defined?(:proj_is_crs) && !Api.proj_is_crs(ptr)
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
      pointer = Api.proj_crs_get_geodetic_crs(self.context, self)
      self.class.create_object(pointer, self.context)
    end

    # Get a CRS component from a CompoundCRS.
    #
    # @see {https://proj.org/development/reference/functions.html#c.proj_crs_get_sub_crs} proj_crs_get_sub_crs
    #
    # @param index [Integer] Index of the CRS component (typically 0 = horizontal, 1 = vertical)
    #
    # @return [Crs]
    def sub_crs(index)
      pointer = Api.proj_crs_get_sub_crs(self.context, self, index)
      self.class.create_object(pointer, self.context)
    end

    # Returns the datum of a SingleCRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum
    #
    # @return [Datum]
    def datum
      ptr = Api.proj_crs_get_datum(self.context, self)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, self.context)
    end

    # Returns a datum for a SingleCRS. If the SingleCRS has a datum, then this datum is returned.
    # Otherwise, the SingleCRS has a datum ensemble, and this datum ensemble is returned as
    # a regular datum instead of a datum ensemble.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum_forced
    #
    # @return [Datum]
    def datum_forced
      pointer = Api.proj_crs_get_datum_forced(self.context, self)
      self.class.create_object(pointer, self.context)
    end

    # Get the horizontal datum from a CRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_horizontal_datum
    #
    # @return [Crs]
    def horizontal_datum
      pointer = Api.proj_crs_get_horizontal_datum(self.context, self)
      self.class.create_object(pointer, self.context)
    end

    # Returns the {DatumEnsemble datum ensemble} of a SingleCRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum_ensemble
    #
    # @return [DatumEnsemble]
    def datum_ensemble
      pointer = Api.proj_crs_get_datum_ensemble(self.context, self)
      self.class.create_object(pointer, self.context)
    end

    # Returns the coordinate system of a SingleCRS.
    #
    # @return [CoordinateSystem]
    def coordinate_system
      pointer = Api.proj_crs_get_coordinate_system(self.context, self)
      CoordinateSystem.new(pointer, self.context)
    end

    # Returns the ellipsoid
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_ellipsoid
    #
    # @return [PjObject]
    def ellipsoid
      pointer = Api.proj_get_ellipsoid(self.context, self)
      self.class.create_object(pointer, self.context)
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
      ptr = Api.proj_crs_get_coordoperation(self.context, self)
      if ptr.null?
        Error.check_object(self)
      end
      self.class.create_object(ptr, self.context)
    end

    # Returns the prime meridian
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_get_prime_meridian
    #
    # @return [PjObject]
    def prime_meridian
      pointer = Api.proj_get_prime_meridian(self.context, self)
      self.class.create_object(pointer, self.context)
    end

    # Returns a list of matching reference CRS, and the percentage (0-100) of confidence in the match.
    #
    # @param auth_name [String] - Authority name, or nil for all authorities
    #
    # @return [Array] - Array of CRS objects sorted by decreasing confidence.
    def identify(auth_name)
      confidences_out_ptr = FFI::MemoryPointer.new(:pointer)
      pointer = Api.proj_identify(self.context, self, auth_name, nil, confidences_out_ptr)
      objects = PjObjects.new(pointer, self.context)

      # Get confidences and free the list
      confidences_ptr = confidences_out_ptr.read_pointer
      confidences = confidences_ptr.read_array_of_type(:int, :read_int, objects.count)
      Api.proj_int_list_destroy(confidences_ptr)

      return objects, confidences
    end

    # Returns whether a CRS is a Derived CRS
    #
    # @return [Boolean] - True if the CRS is derived
    def derived?
      result = Api.proj_is_derived_crs(self.context, self)
      result == 1 ? true : false
    end

    # Return a copy of the CRS with its name changed
    #
    # @param name [String] The new name of the CRS
    #
    # @return [Crs]
    def alter_name(name)
      ptr = Api.proj_alter_name(self.context, self, name)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Return a copy of the CRS with its identifier changed
    #
    # @param auth_name [String] The new authority name of the CRS
    # @param code [String] The new code of the CRS
    #
    # @return [Crs]
    def alter_id(auth_name, code)
      ptr = Api.proj_alter_id(self.context, self, auth_name, code)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Return a copy of the CRS with its geodetic CRS changed.
    #  * If the CRS is a GeodeticCRS then a clone of new_geod_crs is returned.
    #  * If the CRS is a ProjectedCRS, then it replaces the base CRS with new_geod_crs.
    #  * If the CRS is a CompoundCRS, then it replaces the GeodeticCRS part of the horizontal
    #      CRS with new_geod_crs.
    #  * In other cases, it returns a clone of obj.
    #
    # @param new_geod_crs [Crs] A GeodeticCRS
    #
    # @return [Crs]
    def alter_geodetic_crs(new_geod_crs)
      ptr = Api.proj_crs_alter_geodetic_crs(self.context, self, new_geod_crs)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Return a copy of the CRS with its angular units changed
    #
    # @param angular_units [String] Name of the angular units. Or nil for degrees.
    # @param angular_units_conv [Float] Conversion factor from the angular unit to radians. Default is 0 if angular_units is nil
    # @param unit_auth_name [String]  Unit authority name. Defaults to nil.
    # @param unit_code [String] Unit code. Defaults to nil.
    #
    # @return [Crs]
    def alter_cs_angular_unit(angular_units: nil, angular_units_conv: 0, unit_auth_name: nil, unit_code: nil)
      ptr = Api.proj_crs_alter_cs_angular_unit(self.context, self, angular_units, angular_units_conv, unit_auth_name, unit_code)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Return a copy of the CRS with its linear units changed. The CRS
    # must be or contain a ProjectedCRS, VerticalCRS or a GeocentricCRS.
    #
    # @param linear_units [String] Name of the linear units. Or nil for meters.
    # @param linear_units_conv [Float] Conversion factor from the linear unit to meters. Default is 0 if linear_units is nil
    # @param unit_auth_name [String]  Unit authority name. Defaults to nil.
    # @param unit_code [String] Unit code. Defaults to nil.
    #
    # @return [Crs]
    def alter_cs_linear_unit(linear_units: nil, linear_units_conv: 0, unit_auth_name: nil, unit_code: nil)
      ptr = Api.proj_crs_alter_cs_linear_unit(self.context, self, linear_units, linear_units_conv, unit_auth_name, unit_code)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Return a copy of the CRS with its linear units changed. The CRS
    # must be or contain a ProjectedCRS, VerticalCRS or a GeocentricCRS.
    #
    # @param linear_units [String] Name of the linear units. Or nil for meters.
    # @param linear_units_conv [Float] Conversion factor from the linear unit to meters. Default is 0 if linear_units is nil
    # @param unit_auth_name [String]  Unit authority name. Defaults to nil.
    # @param unit_code [String] Unit code. Defaults to nil.
    # @param convert_to_new_unit [Boolean] If true then existing values will be converted from
    #  their current unit to the new unit. If false then their values will be left unchanged
    #  and the unit overridden (so the resulting CRS will not be equivalent to the
    #  original one for reprojection purposes).
    #
    # @return [Crs]
    def alter_parameters_linear_unit(linear_units: nil, linear_units_conv: 0, unit_auth_name: nil, unit_code: nil, convert_to_new_unit:)
      ptr = Api.proj_crs_alter_parameters_linear_unit(self.context, self, linear_units, linear_units_conv,
                                                      unit_auth_name, unit_code,
                                                      convert_to_new_unit ? 1 : 0)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Create a 3D CRS from this 2D CRS. The new axis will be ellipsoidal height,
    # oriented upwards, and with metre units.
    #
    # @param name [String] CRS name. If nil then the name of this CRS will be used.
    #
    # @return [Crs]
    def promote_to_3d(name: nil)
      ptr = Api.proj_crs_promote_to_3D(self.context, name, self)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Create a 2D CRS from an this 3D CRS.
    #
    # @param name [String] CRS name. If nil then the name of this CRS will be used.
    #
    # @return [Crs]
    def demote_to_2d(name: nil)
      ptr = Api.proj_crs_demote_to_2D(self.context, name, self)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end

    # Create a projected 3D CRS from this projected 2D CRS.
    # 
    # This CRS's name is replaced by the name parameter and its base geographic CRS
    # is replaced by geog_3D_crs. The vertical axis of geog_3D_crs (ellipsoidal height)
    # will be added as the 3rd axis of the resulting projected 3D CRS.
    #
    # Normally, the passed geog_3D_crs should be the 3D counterpart of the original
    # 2D base geographic CRS of projected_2D_crs, but such no check is done.
    # 
    # It is also possible to invoke this function with a nil geog_3D_crs. In this case
    # the existing base geographic of this CRS will be automatically promoted to 3D by
    # assuming a 3rd axis being an ellipsoidal height, oriented upwards, and with metre units.
    # This is equivalent to using Crs#promote_to_3d
    #
    # @param name [String] CRS name. If nil then the name of this CRS will be used.
    # @param geog_3d_crs [Crs] Base geographic 3D CRS for the new CRS. Defaults to nil.
    #
    # @return [Crs]
    def projected_3d(name: nil, geog_3d_crs: nil)
      ptr = Api.proj_crs_create_projected_3D_crs_from_2D(self.context, name, self, geog_3d_crs)

      if ptr.null?
        Error.check_object(self)
      end

      self.class.create_object(ptr, context)
    end
  end
end