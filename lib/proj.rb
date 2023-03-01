# encoding: UTF-8

require_relative 'api/api'
require_relative 'proj/config'

require_relative 'proj/bounds'
require_relative 'proj/coordinate_system'
require_relative 'proj/crs_info'
require_relative 'proj/database'
require_relative 'proj/context'
require_relative 'proj/coordinate'
require_relative 'proj/ellipsoid'
require_relative 'proj/error'
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
  def self.info
    Api.proj_info
  end

  def self.version
    self.info[:version]
  end
end

Proj::Config.instance.set_search_paths

at_exit do
  # Clean up any Proj allocated resources on exit. See https://proj.org/development/reference/functions.html#c.proj_cleanup
  Proj::Api.proj_cleanup
end
