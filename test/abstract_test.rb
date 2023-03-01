require 'bundler/setup'
require 'minitest/autorun'
require 'proj'

class AbstractTest < Minitest::Test
  def self.proj8?
    Proj::Api::PROJ_VERSION >= Gem::Version.new("8.0.0") && Proj::Api::PROJ_VERSION < Gem::Version.new("9.0.0")
  end

  def self.proj9?
    Proj::Api::PROJ_VERSION >= Gem::Version.new("9.0.0") && Proj::Api::PROJ_VERSION < Gem::Version.new("10.0.0")
  end

  def proj8?
    self.class.proj8?
  end

  def proj9?
    self.class.proj9?
  end
end

