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
        Error.check
      end

      super(pointer, context)

      if Api.method_defined?(:proj_is_crs) && !Api.proj_is_crs(pointer)
        raise(Error, "Invalid crs definition. Proj created an instance of: #{self.proj_type}.")
      end
    end

    # Get the geodeticCRS / geographicCRS from a CRS.
    #
    # @return [Crs]
    def geodetic_crs
      PjObject.new(Api.proj_crs_get_geodetic_crs(self.context, self))
    end

    # Get a CRS component from a CompoundCRS.
    #
    # @return [Crs]
    def sub_crs(index)
      PjObject.new(Api.proj_crs_get_sub_crs(self.context, self, index))
    end

    # Returns the datum of a SingleCRS.
    #
    # @return [Crs]
    def datum
      PjObject.new(Api.proj_crs_get_datum(self.context, self))
    end

    # Get the horizontal datum from a CRS.
    #
    # @return [Crs]
    def horizontal_datum
      PjObject.new(Api.proj_crs_get_horizontal_datum(self.context, self))
    end

    # Returns the coordinate system of a SingleCRS.
    #
    # @return [Crs]
    def coordinate_system
      PjObject.new(Api.proj_crs_get_coordinate_system(self.context, self))
    end

    # Returns the number of axis of the coordinate system.
    #
    # @return [Integer]
    def axis_count
      result = Api.proj_cs_get_axis_count(self.context, self.coordinate_system)
      if result == -1
        Error.check
      end
      result
    end

    # Returns information on an axis.
    #
    # @return [Array<Hash>]
    def axis_info
      self.axis_count.times.map do |index|
        p_name = FFI::MemoryPointer.new(:pointer)
        p_abbreviation = FFI::MemoryPointer.new(:pointer)
        p_direction = FFI::MemoryPointer.new(:pointer)
        p_unit_conv_factor = FFI::MemoryPointer.new(:double)
        p_unit_name = FFI::MemoryPointer.new(:pointer)
        p_unit_auth_name = FFI::MemoryPointer.new(:pointer)
        p_unit_code = FFI::MemoryPointer.new(:pointer)

        result = Api.proj_cs_get_axis_info(self.context, self.coordinate_system, index,
                                           p_name, p_abbreviation, p_direction, p_unit_conv_factor, p_unit_name, p_unit_auth_name, p_unit_code)

        unless result
          Error.check
        end

        {:name => p_name.read_pointer.read_string,
         :abbreviation => p_abbreviation.read_pointer.read_string_to_null,
         :direction => p_direction.read_pointer.read_string_to_null,
         :unit_conv_factor => p_unit_conv_factor.read_double,
         :unit_name => p_unit_name.read_pointer.read_string_to_null,
         :unit_auth_name => p_unit_auth_name.read_pointer.read_string_to_null,
         :unit_code => p_unit_code.read_pointer.read_string_to_null}
      end
    end

    # Returns the type of the coordinate system.
    #
    # @return [:PJ_COORDINATE_SYSTEM_TYPE]
    def crs_type
      result = Api.proj_cs_get_type(self.context, self.coordinate_system)
      if result == :PJ_CS_TYPE_UNKNOWN
        Error.check
      end
      result
    end

    # Return the area of use of an object.
    #
    # @return [Area]
    def area
      @area ||= Area.for_object(self)
    end

    # Get the ellipsoid from a CRS or a GeodeticReferenceFrame.
    #
    # @return [PjObject]
    def ellipsoid
      PjObject.new(Api.proj_get_ellipsoid(self.context, self))
    end

    # Return the Conversion of a DerivedCRS (such as a ProjectedCRS), or the Transformation from
    # the baseCRS to the hubCRS of a BoundCRS.
    #
    # @return [PjObject]
    def operation
      pointer = Api.proj_crs_get_coordoperation(self.context, self)
      if pointer.null?
        Error.check
      end
      PjObject.new(pointer)
    end

    # Get the prime meridian of a CRS or a GeodeticReferenceFrame.
    #
    # @return [PjObject]
    def prime_meridian
      PjObject.new(Api.proj_get_prime_meridian(self.context, self))
    end

    # A nicely printed out description
    #
    # @return [String]
    def inspect
      result = StringIO.new
      result.set_encoding('UTF-8')
      result << <<~EOS
                  <#{self.class.name}>: #{self.auth(0)}
                  #{self.description}
                  Axis Info [#{self.crs_type}]:
                EOS

      self.axis_info.each do |axis_info|
        result << "- #{axis_info[:abbreviation]}[#{axis_info[:direction]}]: #{axis_info[:name]} (#{axis_info[:unit_name]})" << "\n"
      end

      result << <<~EOS
                  Area of Use:
                  - name: #{self.area.name}
                  - bounds: (#{self.area.west_lon_degree}, #{self.area.south_lat_degree}, #{self.area.east_lon_degree}, #{self.area.north_lat_degree})
                  Coordinate operation:
                  - name: ?
                  - method: ?
                  Datum: #{self.datum.name}
                  - Ellipsoid: #{self.ellipsoid.name}
                  - Prime Meridian: #{self.prime_meridian.name}
                EOS

      result.string
    end
  end
end
