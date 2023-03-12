module Proj
  class Unit
    # @!attribute [r] auth_name
    #   @return [String] Authority name
    # @!attribute [r] code
    #   @return [String] Object code
    # @!attribute [r] name
    #   @return [String] Object name. For example "metre", "US survey foot", etc
    # @!attribute [r] category
    #   @return [String] Category of the unit: one of "linear", "linear_per_time", "angular", "angular_per_time", "scale", "scale_per_time" or "time"
    # @!attribute [r] conv_factor
    #   @return [String] Conversion factor to apply to transform from that unit to the corresponding SI unit (metre for "linear", radian for "angular", etc.). It might be 0 in some cases to indicate no known conversion factor
    # @!attribute [r] proj_short_name
    #   @return [String] PROJ short name, like "m", "ft", "us-ft", etc... Might be nil
    # @!attribute [r] deprecated
    #   @return [Boolean] Whether the object is deprecated
    attr_reader :auth_name, :code, :name, :category, :conv_factor, :proj_short_name, :deprecated

    # Returns a list of built in Units. This is deprecated. Use Database#units instead
    def self.built_in(auth_name: nil, category: nil, allow_deprecated: false)
      # First get linear units
      pointer_to_array = FFI::Pointer.new(Api::PJ_UNITS, Api.proj_list_units)
      result = Array.new
      0.step do |i|
        unit_info = Api::PJ_UNITS.new(pointer_to_array[i])
        break if unit_info[:id].nil?
        result << self.new('PROJ', unit_info[:id], unit_info[:name],
                           'length', unit_info[:factor], unit_info[:id], false)
      end

      # Now get angular linear units
      if Api.method_defined?(:proj_list_angular_units)
        pointer_to_array = FFI::Pointer.new(Api::PJ_UNITS, Api.proj_list_angular_units)
        0.step do |i|
          unit_info = Api::PJ_UNITS.new(pointer_to_array[i])
          break result if unit_info[:id].nil?
          result << self.new('PROJ', unit_info[:id], unit_info[:name],
                             'angular', unit_info[:factor], unit_info[:id], false)
        end
      end

      if auth_name
        result = result.find_all {|unit_info| unit_info.auth_name == auth_name}
      end

      if category
        result = result.find_all {|unit_info| unit_info.category == category}
      end
      result
    end

    # Create a new Unit
    # 
    # @param auth_name [String] Authority name
    # @param code [String] Object code
    # @param name [String] Object name. For example "metre", "US survey foot", etc
    # @param category [String] Category of the unit: one of "linear", "linear_per_time", "angular", "angular_per_time", "scale", "scale_per_time" or "time"
    # @param conv_factor [String] Conversion factor to apply to transform from that unit to the corresponding SI unit (metre for "linear", radian for "angular", etc.). It might be 0 in some cases to indicate no known conversion factor
    # @param proj_short_name [String] PROJ short name, like "m", "ft", "us-ft", etc... Might be nil
    # @param deprecated [Boolean] Whether the object is deprecated
    #
    # @return [Unit]
    def initialize(auth_name, code, name, category, conv_factor, proj_short_name, deprecated)
      @auth_name = auth_name
      @code = code
      @name = name
      @category = category
      @conv_factor = conv_factor
      @proj_short_name = proj_short_name
      @deprecated = deprecated
    end

    def <=>(other)
      self.name <=> other.name
    end

    def ==(other)
      self.code == other.code
    end

    def type
      case self.category
      when "linear"
        :PJ_UT_LINEAR
      when "linear_per_time"
        :PJ_UT_LINEAR
      when "angular"
        :PJ_UT_ANGULAR
      when "angular_per_time"
        :PJ_UT_ANGULAR
      when "scale"
        :PJ_UT_SCALE
      when "scale_per_time"
        :PJ_UT_SCALE
      when "time"
        :PJ_UT_TIME
      end
    end

    def to_s
      self.name
    end
    
    def inspect
      "#<#{self.class} authority=\"#{auth_name}\", code=\"#{code}\", name=\"#{name}\">"
    end
  end
end