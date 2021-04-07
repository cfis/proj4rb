module Proj
  class Ellipsoid
    attr_reader :id, :major, :ell, :name

    def self.list
      pointer_to_array = FFI::Pointer.new(Api::PJ_ELLPS, Api.proj_list_ellps)
      result = Array.new
      0.step do |i|
        ellipse_info = Api::PJ_ELLPS.new(pointer_to_array[i])
        break result if ellipse_info[:id].nil?
        result << self.new(ellipse_info[:id], ellipse_info[:major], ellipse_info[:ell], ellipse_info[:name])
      end
    end

    def self.get(id)
      self.list.find {|ellipsoid| ellipsoid.id == id}
    end

    def initialize(id, major, ell, name)
      @id = id
      @major = major
      @ell = ell
      @name = name
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
      "#<#{self.class} id=\"#{id}\", major=\"#{major}\", ell=\"#{ell}\", name=\"#{name}\">"
    end
  end
end