module Proj
  class PrimeMeridian
    attr_reader :id, :defn

    def self.list
      pointer_to_array = FFI::Pointer.new(Api::PJ_PRIME_MERIDIANS, Api.proj_list_prime_meridians)
      result = Array.new
      0.step do |i|
        prime_meridian_info = Api::PJ_PRIME_MERIDIANS.new(pointer_to_array[i])
        break result if prime_meridian_info[:id].nil?
        result << self.new(prime_meridian_info[:id], prime_meridian_info[:defn])
      end
    end

    def self.get(id)
      self.list.find {|ellipsoid| ellipsoid.id == id}
    end

    def initialize(id, defn)
      @id = id
      @defn = defn
    end

    def <=>(other)
      self.id <=> other.id
    end

    def ==(other)
      self.id == other.id
    end

    def to_s
      self.id
    end
    
    def inspect
      "#<#{self.class} id=\"#{id}\", defn=\"#{defn}\">"
    end
  end
end