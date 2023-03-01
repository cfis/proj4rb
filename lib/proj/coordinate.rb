# encoding: UTF-8

module Proj
  # A four dimensional coordinate of double values.
  #
  # For most geographic Crses, the units will be in degrees.
  class Coordinate
    def self.from_coord(pj_coord)
      result = self.allocate
      result.instance_variable_set(:@coord, pj_coord)
      result
    end

    # Creates a new coordinate.
    #
    # @example
    #
    #    coord = Proj::Coordinate.new(:x => 1, :y => 2, :z => 3, :t => 4)
    #    coord = Proj::Coordinate.new(:u => 5, :v => 6, :w => 7, :t => 8)
    #    coord = Proj::Coordinate.new(:lam => 9, :phi => 10, :z => 11, :t => 12)
    #    coord = Proj::Coordinate.new(:s => 13, :a1 => 14, :a2 => 15)
    #    coord = Proj::Coordinate.new(:o => 16, :p => 17, :k => 18)
    #    coord = Proj::Coordinate.new(:e => 19, :n => 20, :u => 21)

    def initialize(x: nil, y: nil, z: nil, t: nil,
                   u: nil, v: nil, w: nil, # t: nil
                   lam: nil, phi: nil, # z: nil, t: nil,
                   s: nil, a1: nil, a2: nil,
                   o: nil, p: nil, k: nil,
                   e: nil, n: nil) #u: nil

      @coord = Api::PJ_COORD.new

      keys = if x && y && z && t
               [:x, :y, :z, :t]
             elsif x && y && z
               [:x, :y, :z]
             elsif x && y
               [:x, :y]
             elsif u && v && w && t
               [:u, :v, :w, :t]
             elsif u && v && w
               [:u, :v, :w]
             elsif u && v
               [:u, :v]
             elsif lam && phi && z && t
               [:lam, :phi, :z, :t]
             elsif lam && phi && z
               [:lam, :phi, :z]
             elsif lam && phi
               [:lam, :phi]
             elsif s && a1 && a2
               [:s, :a1, :a2]
             elsif e && n && u
               [:e, :n, :u]
             elsif o && p && k
               [:o, :p, :k]
             end

      coord_struct = @coord[:v]
      keys.each_with_index do |key, index|
        coord_struct[index] = binding.local_variable_get(key)
      end
    end

    def to_ptr
      @coord.to_ptr
    end

    # Returns x coordinate
    #
    # @return [Float]
    def x
      @coord[:v][0]
    end

    def xyzt
      @coord[:xyzt]
    end

    # Returns y coordinate
    #
    # @return [Float]
    def y
      @coord[:v][1]
    end

    # Returns z coordinate
    #
    # @return [Float]
    def z
      @coord[:v][2]
    end

    # Returns t coordinate
    #
    # @return [Float]
    def t
      @coord[:v][3]
    end

    # Returns u coordinate
    #
    # @return [Float]
    # TODO - This could be u in uvw or enu. Going to ignore that
    def u
      @coord[:v][0]
    end

    # Returns v coordinate
    #
    # @return [Float]
    def v
      @coord[:v][1]
    end

    # Returns w coordinate
    #
    # @return [Float]
    def w
      @coord[:v][2]
    end

    # Returns lam coordinate
    #
    # @return [Float]
    def lam
      @coord[:v][0]
    end

    # Returns phi coordinate
    #
    # @return [Float]
    def phi
      @coord[:v][1]
    end

    # Returns o coordinate
    #
    # @return [Float]
    def o
      @coord[:v][0]
    end

    # Returns p coordinate
    #
    # @return [Float]
    def p
      @coord[:v][1]
    end

    # Returns k coordinate
    #
    # @return [Float]
    def k
      @coord[:v][3]
    end

    # Returns e coordinate
    #
    # @return [Float]
    def e
      @coord[:v][0]
    end

    # Returns n coordinate
    #
    # @return [Float]
    def n
      @coord[:v][1]
    end

    # Returns s coordinate
    #
    # @return [Float]
    def s
      @coord[:v][0]
    end

    # Returns a1 coordinate
    #
    # @return [Float]
    def a1
      @coord[:v][1]
    end

    # Returns a2 coordinate
    #
    # @return [Float]
    def a2
      @coord[:v][2]
    end

    # Returns nice printout of coordinate contents
    #
    # @return [String]
    def to_s
      "v0: #{self.x}, v1: #{self.y}, v2: #{self.z}, v3: #{self.t}"
    end
  end
end
