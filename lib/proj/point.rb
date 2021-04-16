# encoding: UTF-8

module Proj
  # @deprecated This class is *DEPRECATED.* It will be removed when Proj 7 is released and removes the
  #   underlying API's this class uses. Code should be ported to use Coordinate objects.
  class Point
    def self.from_pointer(pointer)
      result = self.allocate
      result.instance_variable_set(:@struct, pointer)
      result
    end

    # Create new Point object from coordinates.
    def initialize(x, y)
      @struct = Api::ProjUV.new
      @struct[:u] = x
      @struct[:v] = y
    end

    def to_ptr
      @struct.to_ptr
    end

    def to_radians
      self.class.new(Api.proj_torad(self.x), Api.proj_torad(self.y))
    end

    def to_degrees
      self.class.new(Api.proj_todeg(self.x), Api.proj_todeg(self.y))
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
