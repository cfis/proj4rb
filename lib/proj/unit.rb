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

    if Api.method_defined?(:proj_get_units_from_database)
      # Returns a list of units from the database
      #
      # @see https://proj.org/development/reference/functions.html#c.proj_get_units_from_database proj_get_units_from_database
      #
      # @param auth_name [String] Authority name, used to restrict the search. Or nil for all authorities.
      # @param category [String] Filter by category, if this parameter is not nil. Category is one of "linear", "linear_per_time", "angular", "angular_per_time", "scale", "scale_per_time" or "time
      # @param allow_deprecated [Boolean] Whether deprecated units should also be returned. Default false.
      #
      # @return [Array<Unit>] Array of units
      def self.list(auth_name: nil, category: nil, allow_deprecated: false)
        # Create pointer to read the count output parameter
        p_count = FFI::MemoryPointer.new(:pointer, 1)
        # Get the list which is an array of pointers to structures
        pp_units = Api.proj_get_units_from_database(Context.current, auth_name, category, allow_deprecated ? 1 : 0, p_count)
        count = p_count.read(:int)
        array_p_units = pp_units.read_array_of_pointer(count)

        result = Array.new(count)
        result.size.times do |i|
          p_units = FFI::Pointer.new(array_p_units[i])
          unit_info = Api::PROJ_UNIT_INFO.new(array_p_units[i])

          result[i] = self.new(unit_info[:auth_name], unit_info[:code], unit_info[:name],
                               unit_info[:category], unit_info[:conv_factor], unit_info[:proj_short_name],
                               unit_info[:deprecated])
        end

        Api.proj_unit_list_destroy(pp_units)

        result
      end
    else
      def self.list(auth_name: nil, category: nil, allow_deprecated: false)
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

    def to_s
      self.name
    end
    
    def inspect
      "#<#{self.class} authority=\"#{auth_name}\", code=\"#{code}\", name=\"#{name}\">"
    end
  end
end