module Proj
  class Bounds
    attr_reader :name, :xmin, :ymin, :xmax, :ymax

    def self.for_object(pj_object)
      pj_object.area_of_use
    end

    def initialize(xmin, ymin, xmax, ymax, name = nil)
      @xmin = xmin
      @ymin = ymin
      @xmax = xmax
      @ymax = ymax
      @name = name
    end
  end
end
