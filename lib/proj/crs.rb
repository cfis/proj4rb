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
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_geodetic_crs proj_crs_get_geodetic_crs
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
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum proj_crs_get_datum
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
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum_forced proj_crs_get_datum_forced
    #
    # @return [Datum]
    def datum_forced
      ptr = Api.proj_crs_get_datum_forced(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Get the horizontal datum from a CRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_horizontal_datum proj_crs_get_horizontal_datum
    #
    # @return [Crs]
    def horizontal_datum
      ptr = Api.proj_crs_get_horizontal_datum(self.context, self)
      PjObject.create_object(ptr, self.context)
    end

    # Returns the {DatumEnsemble datum ensemble} of a SingleCRS.
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_crs_get_datum_ensemble proj_crs_get_datum_ensemble
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
    # @see https://proj.org/development/reference/functions.html#c.proj_get_ellipsoid proj_get_ellipsoid
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
    # @see https://proj.org/development/reference/functions.html#c.proj_get_prime_meridian proj_get_prime_meridian
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
  end
end
