module Proj
  class Unit
    attr_reader :id, :to_meter, :factor, :name

    def self.list
      # First get linear units
      pointer_to_array = FFI::Pointer.new(Api::PJ_UNITS, Api.proj_list_units)
      result = Array.new
      0.step do |i|
        ellipse_info = Api::PJ_UNITS.new(pointer_to_array[i])
        break if ellipse_info[:id].nil?
        result << self.new(ellipse_info[:id], ellipse_info[:to_meter], ellipse_info[:factor], ellipse_info[:name])
      end

      # Now get angular linear units
      if Api.method_defined?(:proj_list_angular_units)
        pointer_to_array = FFI::Pointer.new(Api::PJ_UNITS, Api.proj_list_angular_units)
        0.step do |i|
          ellipse_info = Api::PJ_UNITS.new(pointer_to_array[i])
          break result if ellipse_info[:id].nil?
          result << self.new(ellipse_info[:id], ellipse_info[:to_meter], ellipse_info[:factor], ellipse_info[:name])
        end
      end
      result
    end

    def self.get(id)
      self.list.find {|ellipsoid| ellipsoid.id == id}
    end

    def initialize(id, to_meter, factor, name)
      @id = id
      @to_meter = to_meter
      @factor = factor
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
      "#<#{self.class} id=\"#{id}\", to_meter=\"#{to_meter}\", factor=\"#{factor}\", name=\"#{name}\">"
    end
  end
end