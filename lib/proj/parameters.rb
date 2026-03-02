# encoding: UTF-8
module Proj
  class Parameters
    # @!visibility private
    def self.finalize(params)
      proc do
        Api.proj_get_crs_list_parameters_destroy(params)
      end
    end

    def initialize
      @params = Api.proj_get_crs_list_parameters_create
      ObjectSpace.define_finalizer(self, self.class.finalize(@params))
    end

    def to_ptr
      @params.to_ptr
    end
    
    def types
      result = Array.new

      unless @params[:types].null?
        ints = @params[:types].read_array_of_int(@params[:types_count])
        ints.each do |int|
          result << Api::PjType[int]
        end
      end
      result
    end

    def types=(values)
      ptr = FFI::MemoryPointer.new(:int, values.size)
      ints = values.map {|symbol| Api::PjType[symbol]}
      ptr.write_array_of_int(ints)

      @params[:types] = ptr
      @params[:types_count] = values.size
    end

    def crs_area_of_use_contains_bbox
      @params[:crs_area_of_use_contains_bbox]
    end

    def crs_area_of_use_contains_bbox=(value)
      @params[:crs_area_of_use_contains_bbox] = value
    end

    def bbox_valid
      @params[:bbox_valid] == 1 ? true : false
    end

    def bbox_valid=(value)
      @params[:bbox_valid] = value ? 1 : 0
    end

    def west_lon_degree
      @params[:west_lon_degree]
    end

    def west_lon_degree=(value)
      @params[:west_lon_degree] = value
    end

    def south_lat_degree
      @params[:south_lat_degree]
    end

    def south_lat_degree=(value)
      @params[:south_lat_degree] = value
    end

    def east_lon_degree
      @params[:east_lon_degree]
    end

    def east_lon_degree=(value)
      @params[:east_lon_degree] = value
    end

    def north_lat_degree
      @params[:north_lat_degree]
    end

    def north_lat_degree=(value)
      @params[:north_lat_degree] = value
    end

    def allow_deprecated
      @params[:allow_deprecated] == 1 ? true : false
    end

    def allow_deprecated=(value)
      @params[:allow_deprecated] = value ? 1 : 0
    end

    def celestial_body_name
      @params[:celestial_body_name]
    end

    def celestial_body_name=(value)
      ptr = FFI::MemoryPointer.from_string(value)
      @params.pointer.put_pointer(@params.offset_of(:celestial_body_name), ptr)
    end
  end
end
