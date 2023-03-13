module Proj
  class AxisInfo
    # @!attribute [r] name
    #   @return [String] Axis name
    # @!attribute [r] abbreviation
    #   @return [String] Axis abbreviation
    # @!attribute [r] direction
    #   @return [String] Axis direction
    # @!attribute [r] unit_conv_factor
    #   @return [String] Axis unit_conv_factor
    # @!attribute [r] unit_name
    #   @return [String] Axis unit_name
    # @!attribute [r] unit_auth_name
    #   @return [String] Axis unit_auth_name
    # @!attribute [r] unit_code
    #   @return [String] Axis unit_code
    attr_reader :name, :abbreviation, :direction,
                :unit_name, :unit_auth_name, :unit_code, :unit_conv_factor

      def initialize(name:, abbreviation:, direction:, unit_conv_factor:, unit_name:, unit_auth_name:, unit_code:)
      @name = name
      @abbreviation = abbreviation
      @direction = direction
      @unit_conv_factor = unit_conv_factor
      @unit_name = unit_name
      @unit_auth_name = unit_auth_name
      @unit_code = unit_code
    end

    # Returns axis information in PJ_AXIS_DESCRIPTION structure
    #
    # @return [PJ_AXIS_DESCRIPTION]
    def to_description
      Api::PJ_AXIS_DESCRIPTION.create(name: name, abbreviation: abbreviation, direction: direction,
                                      unit_conv_factor: unit_conv_factor, unit_name: name, unit_type: self.unit_type)
    end
    
    def unit_type
      database = Database.new(Context.default)
      unit = database.unit(self.unit_auth_name, self.unit_code)
      unit.unit_type
    end
  end
end