# encoding: UTF-8

module Proj
  # This class represents a point in either lon/lat or projected x/y coordinates.
  class Point
    def self.from_pointer(pointer)
      result = self.allocate
      result.instance_variable_set(:@struct, pointer)
      result
    end

    # Create new Proj4::Point object from coordinates.
    def initialize(x, y, z=0)
      @struct = Api::ProjUVW.new
      @struct[:u] = x
      @struct[:v] = y
      @struct[:w] = z
    end

    def to_ptr
      @struct.to_ptr
    end

    def to_radians
      self.class.new(Api.proj_torad(self.x), Api.proj_torad(self.y), Api.proj_torad(self.z))
    end

    def to_degrees
      self.class.new(Api.proj_todeg(self.x), Api.proj_todeg(self.y), Api.proj_todeg(self.z))
    end

    # Get x coordinate.
    def x
      @struct[:u]
    end

    # Set x coordinate.
    def x=(value)
      @struct[:u] = value
    end

    # Get y coordinate.
    def y
      @struct[:v]
    end

    # Set y coordinate.
    def y=(value)
      @struct[:v] = value
    end

    # Get z coordinate.
    def z
      @struct[:w]
    end

    # Set z coordinate.
    def z=(value)
      @struct[:w] = value
    end

    # Get longitude/x coordinate.
    def lon
      @struct[:u]
    end

    # Set longitude/x coordinate.
    def lon=(value)
      @struct[:u] = value
    end

    # Get latitude/y coordinate.
    def lat
      @struct[:v]
    end

    # Set latitude/y coordinate.
    def lat=(value)
      @struct[:v] = value
    end
  end
end
