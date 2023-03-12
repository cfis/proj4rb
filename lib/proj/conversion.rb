# encoding: UTF-8
require 'stringio'

module Proj
  # Conversions are {CoordinateOperationMix coordinate operations} that convert a source
  # {Coordinate coordinate} to a new value. In Proj they are defined as operations that
  # do not exert a change in reference frame while {Transformation transformations } do.
  class Conversion < PjObject
    include CoordinateOperationMixin
    extend Projections

    # Instantiate a Conversion

    # Create a Transformation
    #
    # @param context [Context] Context
    # @param name [String] Name of the transformation. Default is nil.
    # @param auth_name [String] Transformation authority name. Default is nil.
    # @param code [String] Transformation code. Default is nil.
    # @param method_name [String] Method name. Default is nil.
    # @param method_auth_name [String] Method authority name. Default is nil.
    # @param method_code [String] Method code. Default is nil.
    # @param params [Array<Parameter>] Parameter descriptions
    # @param accuracy [Double] Accuracy of the transformation in meters. A negative value means unknown.
    #
    # @return [Conversion]
    def self.create_conversion(context, name:, auth_name:, code:, method_name:, method_auth_name:, method_code:, params:)
      params_ptr = FFI::MemoryPointer.new(Api::PJ_PARAM_DESCRIPTION, params.size)
      params.each_with_index do |param, i|
        param_description_target = Api::PJ_PARAM_DESCRIPTION.new(params_ptr[i])
        param_description_source = param.to_description
        param_description_target.to_ptr.__copy_from__(param_description_source.to_ptr, Api::PJ_PARAM_DESCRIPTION.size)
      end

      pointer = Api.proj_create_conversion(context, name, auth_name, code, method_name, method_auth_name, method_code, params.size, params_ptr)
      Error.check_context(context)
      self.create_object(pointer, context)
    end

    # Instantiates an conversion from a string. The string can be:
    #
    # * proj-string,
    # * WKT string,
    # * object code (like "EPSG:4326", "urn:ogc:def:crs:EPSG::4326", "urn:ogc:def:coordinateOperation:EPSG::1671"),
    # * Object name. e.g "WGS 84", "WGS 84 / UTM zone 31N". In that case as uniqueness is not guaranteed, heuristics are applied to determine the appropriate best match.
    # * OGC URN combining references for compound coordinate reference systems (e.g "urn:ogc:def:crs,crs:EPSG::2393,crs:EPSG::5717" or custom abbreviated syntax "EPSG:2393+5717"),
    # * OGC URN combining references for concatenated operations (e.g. "urn:ogc:def:coordinateOperation,coordinateOperation:EPSG::3895,coordinateOperation:EPSG::1618")
    # * PROJJSON string. The jsonschema is at https://proj.org/schemas/v0.4/projjson.schema.json (added in 6.2)
    # * compound CRS made from two object names separated with " + ". e.g. "WGS 84 + EGM96 height" (added in 7.1)
    #
    # @see https://proj.org/development/reference/functions.html#c.proj_create
    #
    # @param value [String]. See above
    #
    # @return [Conversion]
    def initialize(value, context=nil)
      context ||= Context.current
      ptr = Api.proj_create(context, value)

      if ptr.null?
        Error.check_context(context)
      end

      if Api.method_defined?(:proj_is_crs) && Api.proj_is_crs(ptr)
        raise(Error, "Invalid conversion. Proj created an instance of: #{self.proj_type}.")
      end

      super(ptr, context)
    end

    def convert_to_other_method(new_method_epsg_code, new_method_name)
      ptr = Api.proj_convert_conversion_to_other_method(self.context, self, new_method_epsg_code, new_method_name)
      self.create_object(ptr, context)
    end
  end
end
