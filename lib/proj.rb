# encoding: UTF-8

require_relative './api'
require_relative './config'

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

  def self.set_data_path
    path = Config.instance.data_path
    p_path = FFI::MemoryPointer.from_string(path)
    p_paths = FFI::MemoryPointer.new(:pointer, 1)
    p_paths[0].write_pointer(p_path)
    Api.pj_set_searchpath(1, p_paths)
  end
  self.set_data_path
end