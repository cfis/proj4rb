module Proj
  class Parameter
    # @!attribute [r] name
    #   @return [String] Param name
    # @!attribute [r] auth_name
    #   @return [String] Authority name
    # @!attribute [r] code
    #   @return [String] Authority code
    # @!attribute [r] value
    #   @return [String] Param value
    # @!attribute [r] unit_conv_factor
    #   @return [String] Param unit_conv_factor
    # @!attribute [r] unit_name
    #   @return [String] Param unit_name
    # @!attribute [r] unit_type
    #   @return [PjUnitType] Unit type
    attr_reader :name, :auth_name, :code, :value,
                :unit_conv_factor, :unit_name, :unit_type

    def initialize(name:, auth_name: nil, code: nil, value:, unit_conv_factor:, unit_name: nil, unit_type:)
      @name = name
      @auth_name = auth_name
      @code = code
      @value = value
      @unit_conv_factor = unit_conv_factor
      @unit_name = unit_name
      @unit_type = unit_type
    end

    # Returns param information in PjParamDescription structure
    #
    # @return [PjParamDescription]
    def to_description
      Api::PjParamDescription.create(name: name, auth_name: auth_name, code: code, value: value,
                                     unit_conv_factor: unit_conv_factor, unit_name: unit_name, unit_type: unit_type)
    end
  end
end