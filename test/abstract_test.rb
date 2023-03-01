require 'bundler/setup'
require 'minitest/autorun'
require 'proj'

class AbstractTest < Minitest::Test
  def proj8?
    Proj::Api::PROJ_VERSION >= Gem::Version.new("8.0.0") && Proj::Api::PROJ_VERSION < Gem::Version.new("9.0.0")
  end

  def proj9?
    Proj::Api::PROJ_VERSION >= Gem::Version.new("9.0.0") && Proj::Api::PROJ_VERSION < Gem::Version.new("10.0.0")
  end
end

