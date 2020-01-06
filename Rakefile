#!/usr/bin/env ruby

require "rubygems"
require "rake/testtask"
require "rubygems/package_task"
require "yard"
require "yaml"

# Read the spec file
GEM_NAME = "proj4rb"
spec = Gem::Specification.load("#{GEM_NAME}.gemspec")

# Setup generic gem
Gem::PackageTask.new(spec) do |pkg|
  pkg.package_dir = 'pkg'
  pkg.need_tar    = false
end

# Yard Task
desc "Generate documentation"
YARD::Rake::YardocTask.new

# Test Task
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end