#!/usr/bin/env ruby

require "rubygems"
require "rake/extensiontask"
require "rake/testtask"
require "rubygems/package_task"
require "rdoc/task"
require "yaml"

# Read the spec file
GEM_NAME = "proj4rb"
SO_NAME = "proj4_ruby"
spec = Gem::Specification.load("#{GEM_NAME}.gemspec")

# Setup generic gem
Gem::PackageTask.new(spec) do |pkg|
  pkg.package_dir = 'pkg'
  pkg.need_tar    = false
end

# RDoc Task
desc "Generate rdoc documentation"
RDoc::Task.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "Proj4rb"
  # Show source inline with line numbers
  rdoc.options << "--line-numbers"
  # Make the readme file the start page for the generated html
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('doc/*.rdoc',
                          'ext/projrb.c',
                          'README',
                          'proj4rb.gemspec',
                          'Changelog',
                          'MIT-LICENSE')
end

# Test Task
Rake::TestTask.new do |t|
  t.libs << "test"
  t.verbose = true
end