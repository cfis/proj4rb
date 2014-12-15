# encoding: utf-8
require 'rake'


# ------- Default Package ----------
FILES = FileList[
  'Rakefile',
  'README.rdoc',
  'MIT-LICENSE',
  'data/**/*',
  'doc/**/*',
  'example/**/*',
  'ext/*',
  'ext/vc/*.sln',
  'ext/vc/*.vcproj',
  'lib/**/*.rb'
]

Gem::Specification.new do |spec|
  spec.name = 'proj4rb'
  spec.version = '0.4.4'
  spec.summary = 'Ruby bindings for the Proj.4 Carthographic Projection library'
  spec.description = <<-EOF
    Proj4rb is a ruby binding for the Proj.4 Carthographic Projection library, that supports conversions between a very large number of geographic coordinate systems and datumspec.
  EOF
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Guilhem Vellut', 'Jochen Topf', 'Charlie Savage']
  spec.homepage = 'https://github.com/cfis/proj4rb'
  spec.required_ruby_version = '>= 1.8.7'
  spec.date = DateTime.now
  spec.license = 'MIT'

  spec.requirements << 'Proj.4 C library'
  spec.require_path = 'lib'
  spec.extensions = ['ext/extconf.rb']
  spec.files = FILES.to_a
  spec.test_files = FileList['test/test*.rb']
end