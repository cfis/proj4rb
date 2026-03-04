module Proj
  # Represents a 2D bounding box defined by minimum and maximum x/y values.
  # Used with {CoordinateOperationMixin#transform_bounds} to transform rectangular
  # regions between coordinate reference systems.
  class Bounds
    # @!attribute [r] xmin
    #   @return [Float] Minimum x value (e.g., west longitude)
    # @!attribute [r] ymin
    #   @return [Float] Minimum y value (e.g., south latitude)
    # @!attribute [r] xmax
    #   @return [Float] Maximum x value (e.g., east longitude)
    # @!attribute [r] ymax
    #   @return [Float] Maximum y value (e.g., north latitude)
    # @!attribute [r] name
    #   @return [String, nil] Optional name for this bounds
    attr_reader :name, :xmin, :ymin, :xmax, :ymax

    # Creates a new 2D bounding box.
    #
    # @param xmin [Float] Minimum x value
    # @param ymin [Float] Minimum y value
    # @param xmax [Float] Maximum x value
    # @param ymax [Float] Maximum y value
    # @param name [String, nil] Optional name
    #
    # @return [Bounds]
    def initialize(xmin, ymin, xmax, ymax, name = nil)
      @xmin = xmin
      @ymin = ymin
      @xmax = xmax
      @ymax = ymax
      @name = name
    end
  end
end
