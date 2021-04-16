# encoding: UTF-8

require_relative 'api/api'
require_relative 'proj/config'

require_relative 'proj/area'
require_relative 'proj/context'
require_relative 'proj/coordinate'
require_relative 'proj/ellipsoid'
require_relative 'proj/error'
require_relative 'proj/point'
require_relative 'proj/prime_meridian'
require_relative 'proj/unit'

require_relative 'proj/pj_object'
require_relative 'proj/operation'
require_relative 'proj/crs'
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
