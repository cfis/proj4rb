# encoding: UTF-8

require_relative 'api/api'

require_relative 'proj/pj_object'

require_relative 'proj/area'
require_relative 'proj/bounds'
require_relative 'proj/coordinate_system'
require_relative 'proj/crs_info'
require_relative 'proj/context'
require_relative 'proj/coordinate'
require_relative 'proj/database'
require_relative 'proj/datum_ensemble'
require_relative 'proj/ellipsoid'
require_relative 'proj/error'
require_relative 'proj/file_api'
require_relative 'proj/grid'
require_relative 'proj/grid_cache'
require_relative 'proj/grid_info'
require_relative 'proj/network_api'
require_relative 'proj/parameters'
require_relative 'proj/point'
require_relative 'proj/prime_meridian'
require_relative 'proj/session'
require_relative 'proj/unit'

require_relative 'proj/pj_object'
require_relative 'proj/pj_objects'
require_relative 'proj/strings'

require_relative 'proj/coordinate_operation_mixin'
require_relative 'proj/conversion'
require_relative 'proj/operation'
require_relative 'proj/crs'
require_relative 'proj/operation_factory_context'
require_relative 'proj/projection'
require_relative 'proj/transformation'

module Proj
  # Returns information about the Proj library
  #
  # @see https://proj.org/development/reference/functions.html#c.proj_info proj_info
  def self.info
    Api.proj_info
  end

  # Returns the Proj version
  #
  # @see https://proj.org/development/reference/functions.html#c.proj_info proj_info
  def self.version
    self.info[:version]
  end

  # Returns default search paths
  #
  # @see https://proj.org/development/reference/functions.html#c.proj_info proj_info
  #
  # @return Array<string> List of search paths
  def self.search_paths
    self.info[:searchpath].split(";")
  end

  # Return information about the specific init file
  #
  # @see https://proj.org/development/reference/functions.html#c.proj_init_info proj_init_info
  #
  # @param file_name [String] The name of the init file (not the path)
  #
  # @return [PJ_INIT_INFO]
  def self.init_file_info(file_name)
    Api.proj_init_info(file_name)
  end

  # Converts degrees to radians
  #
  # see https://proj.org/development/reference/functions.html#c.proj_torad proj_torad
  #
  # @param value [Double] Value in degrees to convert
  #
  # @return [Double]
  def self.degrees_to_radians(value)
    Api.proj_torad(value)
  end

  # Converts radians degrees
  #
  # see https://proj.org/development/reference/functions.html#c.proj_todeg proj_todeg
  #
  # @param value [Double] Value in radians to convert
  #
  # @return [Double]
  def self.radians_to_degrees(value)
    Api.proj_todeg(value)
  end

  # Convert string of degrees, minutes and seconds to radians.
  #
  # see https://proj.org/development/reference/functions.html#c.proj_dmstor proj_dmstor
  #
  # @param value [String] Value to be converted to radians
  #
  # @return [Double]
  def self.degrees_minutes_seconds_to_radians(value)
    ptr = FFI::MemoryPointer.new(:string)
    Api.proj_dmstor(value, ptr)
  end

  # Convert radians to a string representation of degrees, minutes and seconds
  #
  # @see https://proj.org/development/reference/functions.html#c.proj_rtodms proj_rtodms
  # @see https://proj.org/development/reference/functions.html#c.proj_rtodms2 proj_rtodms2
  #
  # @param value [Double] Value to be converted in radians
  # @param positive [String] Character denoting positive direction, typically 'N' or 'E'. Default 'N'
  # @param negative [String] Character denoting negative direction, typically 'S' or 'W'. Default 'S'
  #
  # @return [String]
  def self.radians_to_degrees_minutes_seconds(value, positive='N', negative='S')
    ptr = FFI::MemoryPointer.new(:char, 100)
    if Api::PROJ_VERSION < Gem::Version.new('9.2.0')
      Api.proj_rtodms(ptr, value, positive.ord, negative.ord)
    else
      Api.proj_rtodms2(ptr, ptr.size, value, positive.ord, negative.ord)
    end
    ptr.read_string_to_null
  end
end

at_exit do
  # Clean up any Proj allocated resources on exit. See https://proj.org/development/reference/functions.html#c.proj_cleanup
  Proj::Api.proj_cleanup
end
