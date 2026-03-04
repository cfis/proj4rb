# encoding: UTF-8

module Proj
  class Bounds3d
    attr_reader :name, :xmin, :ymin, :zmin, :xmax, :ymax, :zmax

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
