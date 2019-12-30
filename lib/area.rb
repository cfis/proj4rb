module Proj
  class Area
    attr_reader :name, :west_lon_degree, :south_lat_degree, :east_lon_degree, :north_lat_degree

    def self.for_object(pj_object)
      p_name = FFI::MemoryPointer.new(:pointer)
      p_west_lon_degree = FFI::MemoryPointer.new(:double)
      p_south_lat_degree = FFI::MemoryPointer.new(:double)
      p_east_lon_degree = FFI::MemoryPointer.new(:double)
      p_north_lat_degree = FFI::MemoryPointer.new(:double)

      result = Api.proj_get_area_of_use(Context.current, pj_object,
                                        p_west_lon_degree, p_south_lat_degree, p_east_lon_degree, p_north_lat_degree,
                                        p_name)
      unless result
        Error.check
      end

      name = p_name.read_pointer.read_string_to_null.force_encoding('utf-8')
      self.new(name,
               p_west_lon_degree.read_double, p_south_lat_degree.read_double, p_east_lon_degree.read_double, p_north_lat_degree.read_double)
    end

    def initialize(name, west_lon_degree, south_lat_degree, east_lon_degree, north_lat_degree)
      @name = name
      @west_lon_degree = west_lon_degree
      @south_lat_degree = south_lat_degree
      @east_lon_degree = east_lon_degree
      @north_lat_degree = north_lat_degree
    end
  end
end
