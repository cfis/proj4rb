module Proj
  class Bounds
    attr_reader :name, :xmin, :ymin, :xmax, :ymax

    def initialize(xmin, ymin, xmax, ymax, name = nil)
      @xmin = xmin
      @ymin = ymin
      @xmax = xmax
      @ymax = ymax
      @name = name
    end
  end
end
