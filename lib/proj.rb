# encoding: UTF-8

require_relative 'api/api'

require_relative 'proj/bounds'
require_relative 'proj/coordinate_system'
require_relative 'proj/crs_info'
require_relative 'proj/database'
require_relative 'proj/context'
require_relative 'proj/coordinate'
require_relative 'proj/ellipsoid'
require_relative 'proj/error'
require_relative 'proj/grid'
require_relative 'proj/grid_cache'
require_relative 'proj/grid_downloader'
require_relative 'proj/grid_info'
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
  def self.search_paths
    self.info[:searchpath].split(";")
  end
end

at_exit do
  # Clean up any Proj allocated resources on exit. See https://proj.org/development/reference/functions.html#c.proj_cleanup
  Proj::Api.proj_cleanup
end
