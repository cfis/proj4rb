# encoding: UTF-8
require 'stringio'

module Proj
  class Crs < PjObject
    def initialize(value, context=nil)
      # Check for old style init strings
      if !context
        if value.match(/\Winit\W/)
          context = Context.new
          context.use_proj4_init_rules = true
        else
          context = Context.current
        end
      end

      pointer = Api.proj_create(context, value)

      if pointer.null?
        Error.check
      end

      super(pointer, context)

      unless Api.proj_is_crs(pointer)
        raise(Error, "Invalid crs definition. Proj created an instance of: #{self.proj_type}.")
      end
    end

    def geodetic_crs
      PjObject.new(Api.proj_crs_get_geodetic_crs(self.context, self))
    end

    def sub_crs(index)
      PjObject.new(Api.proj_crs_get_sub_crs(self.context, self, index))
    end

    def datum
      PjObject.new(Api.proj_crs_get_datum(self.context, self))
    end

    def horizontal_datum
      PjObject.new(Api.proj_crs_get_horizontal_datum(self.context, self))
    end

    def coordinate_system
      PjObject.new(Api.proj_crs_get_coordinate_system(self.context, self))
    end

    def axis_count
      foo = Api.proj_crs_get_coordinate_system(self.context, self)
      result = Api.proj_cs_get_axis_count(self.context, self.coordinate_system)
      if result == -1
        Error.check
      end
      result
    end

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

    def crs_type
      foo = Api.proj_crs_get_coordinate_system(self.context, self)
      result = Api.proj_cs_get_type(self.context, self.coordinate_system)
      if result == :PJ_CS_TYPE_UNKNOWN
        Error.check
      end
      result
    end

    def area
      @area ||= Area.for_object(self)
    end

    def ellipsoid
      PjObject.new(Api.proj_get_ellipsoid(self.context, self))
    end

    def operation
      pointer = Api.proj_crs_get_coordoperation(self.context, self)
      if pointer.null?
        Error.check
      end
      PjObject.new(pointer)
    end

    def prime_meridian
      PjObject.new(Api.proj_get_prime_meridian(self.context, self))
    end

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
