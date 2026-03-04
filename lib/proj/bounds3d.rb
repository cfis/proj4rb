# encoding: UTF-8

module Proj
  # Represents a 3D bounding box defined by minimum and maximum x/y/z values.
  # Used with {CoordinateOperationMixin#transform_bounds_3d} to transform 3D
  # regions between coordinate reference systems. Requires PROJ 9.6+.
  class Bounds3d
    # @!attribute [r] xmin
    #   @return [Float] Minimum x value (e.g., west longitude)
    # @!attribute [r] ymin
    #   @return [Float] Minimum y value (e.g., south latitude)
    # @!attribute [r] zmin
    #   @return [Float] Minimum z value (e.g., lower elevation)
    # @!attribute [r] xmax
    #   @return [Float] Maximum x value (e.g., east longitude)
    # @!attribute [r] ymax
    #   @return [Float] Maximum y value (e.g., north latitude)
    # @!attribute [r] zmax
    #   @return [Float] Maximum z value (e.g., upper elevation)
    # @!attribute [r] name
    #   @return [String, nil] Optional name for this bounds
    attr_reader :name, :xmin, :ymin, :zmin, :xmax, :ymax, :zmax

    # Creates a new 3D bounding box.
    #
    # @param xmin [Float] Minimum x value
    # @param ymin [Float] Minimum y value
    # @param zmin [Float] Minimum z value
    # @param xmax [Float] Maximum x value
    # @param ymax [Float] Maximum y value
    # @param zmax [Float] Maximum z value
    # @param name [String, nil] Optional name
    #
    # @return [Bounds3d]
    def initialize(xmin, ymin, zmin, xmax, ymax, zmax, name = nil)
      @xmin = xmin
      @ymin = ymin
      @zmin = zmin
      @xmax = xmax
      @ymax = ymax
      @zmax = zmax
      @name = name
    end
  end
end
