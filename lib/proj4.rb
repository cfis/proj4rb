# encoding: UTF-8

require_relative './api'

require_relative './area'
require_relative './context'
require_relative './coordinate'
require_relative './ellipsoid'
require_relative './error'
require_relative './point'
require_relative './prime_meridian'
require_relative './unit'

require_relative './pj_object'
require_relative './operation'
require_relative './crs'
require_relative './projection'
require_relative './transformation'

module Proj
  def self.info
    Api.proj_info
  end

  def self.version
    self.info[:version]
  end
end

# Backwards compatibilit
Proj4 = Proj
