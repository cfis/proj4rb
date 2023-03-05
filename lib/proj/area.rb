# encoding: UTF-8

module Proj
  class Area
    attr_reader :name, :west_lon_degree, :south_lat_degree, :east_lon_degree, :north_lat_degree

    def self.finalize(pointer)
      proc do
        Api.proj_area_destroy(pointer)
      end
    end

    def initialize(west_lon_degree:, south_lat_degree:, east_lon_degree:, north_lat_degree:, name: nil)
      @west_lon_degree = west_lon_degree
      @south_lat_degree = south_lat_degree
      @east_lon_degree = east_lon_degree
      @north_lat_degree = north_lat_degree
      @name = name
      create_area
    end

    def to_ptr
      @area
    end

    def set_bounds(west_lon_degree:, south_lat_degree:, east_lon_degree:, north_lat_degree:)
      Api.proj_area_set_bbox(self, west_lon_degree, south_lat_degree, east_lon_degree, north_lat_degree)
    end

    def name=(value)
      @name = name
      Api.proj_area_set_name(self, value)
    end

    # Returns nice printout of coordinate contents
    #
    # @return [String]
    def to_s
      "Area west_lon_degree: #{self.west_lon_degree}, south_lat_degree: #{self.south_lat_degree}, east_lon_degree: #{self.east_lon_degree}, north_lat_degree: #{self.north_lat_degree}"
    end

    private

    def create_area
      @area = Api.proj_area_create
      self.set_bounds(west_lon_degree: west_lon_degree, south_lat_degree: south_lat_degree,
                      east_lon_degree: east_lon_degree, north_lat_degree: north_lat_degree)
      if name
        self.name = name
      end
      ObjectSpace.define_finalizer(self, self.class.finalize(@area))
    end
  end
end
