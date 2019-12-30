# encoding: UTF-8

module Proj
  class Coordinate
    def self.from_coord(pj_coord)
      result = self.allocate
      result.instance_variable_set(:@coord, pj_coord)
      result
    end

    def initialize(x: nil, y: nil, z: nil, t: nil,
                   u: nil, v: nil, w: nil, # t: nil
                   lam: nil, phi: nil, # z: nil, t: nil,
                   o: nil, p: nil, k: nil,
                   e: nil, n: nil, #u: nil,
                   s: nil, a1: nil, a2: nil)

      @coord = Proj4::Api::PJ_COORD.new

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
             end

      coord_struct = @coord[:v]
      keys.each_with_index do |key, index|
        coord_struct[index] = binding.local_variable_get(key)
      end
    end

    def to_ptr
      @coord.to_ptr
    end

    def x
      @coord[:v][0]
    end

    def y
      @coord[:v][1]
    end

    def z
      @coord[:v][2]
    end

    def t
      @coord[:v][3]
    end

    # Bleh. This could be u in uvw or enu. Going to ignore that
    def u
      @coord[:v][0]
    end

    def v
      @coord[:v][1]
    end

    def w
      @coord[:v][2]
    end

    def lam
      @coord[:v][0]
    end

    def phi
      @coord[:v][1]
    end

    def o
      @coord[:v][0]
    end

    def p
      @coord[:v][1]
    end

    def k
      @coord[:v][3]
    end

    def e
      @coord[:v][0]
    end

    def n
      @coord[:v][1]
    end

    def s
      @coord[:v][0]
    end

    def a1
      @coord[:v][1]
    end

    def a2
      @coord[:v][2]
    end

    def to_s
      "v0: #{self.x}, v1: #{self.y}, v2: #{self.z}, v3: #{self.t}"
    end
  end
end
