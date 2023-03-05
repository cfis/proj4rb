# encoding: UTF-8

module Proj
  # Areas are used to specify the area of use for the choice of relevant coordinate operations.
  # See Transformation#new
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

    # Sets the bounds for an area
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_area_set_bbox proj_area_set_bbox
    #
    # @param west_lon_degree [Float] West longitude, in degrees. In [-180,180] range.
    # @param south_lat_degree [Float] South latitude, in degrees. In [-90,90] range.
    # @param east_lon_degree [Float] East longitude, in degrees. In [-180,180] range.
    # @param north_lat_degree [Float] North latitude, in degrees. In [-90,90] range.
    def set_bounds(west_lon_degree:, south_lat_degree:, east_lon_degree:, north_lat_degree:)
      Api.proj_area_set_bbox(self, west_lon_degree, south_lat_degree, east_lon_degree, north_lat_degree)
    end

    # Sets the name for an area
    #
    # @param value [String] The name of the area
    def name=(value)
      @name = name
      Api.proj_area_set_name(self, value)
    end

    # Returns nice printout of an Area
    #
    # @return [String]
    def to_s
      "Area west_lon_degree: #{self.west_lon_degree}, south_lat_degree: #{self.south_lat_degree}, east_lon_degree: #{self.east_lon_degree}, north_lat_degree: #{self.north_lat_degree}"
    end

    private

    # Creates an area
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_area_create proj_area_create
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
