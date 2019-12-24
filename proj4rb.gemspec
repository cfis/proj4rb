Gem::Specification.new do |spec|
  spec.name = 'proj4rb'
  spec.version = '1.0.1'
  spec.summary = 'Ruby bindings for the Proj.4 Carthographic Projection library'
  spec.description = <<-EOF
    Proj4rb is a ruby binding for the Proj.4 Carthographic Projection library, that supports conversions between a very large number of geographic coordinate systems and datumspec.
  EOF
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Guilhem Vellut', 'Jochen Topf', 'Charlie Savage']
  spec.homepage = 'https://github.com/cfis/proj4rb'
  spec.required_ruby_version = '>= 2.4.9'
  spec.license = 'MIT'

  spec.requirements << 'Proj (Proj4) Library'
  spec.require_path = 'lib'
  spec.extensions = ['ext/extconf.rb']
  spec.files = Dir['ChangeLog',
                   'Gemfile',
                   'MIT-LICENSE',
                   'proj4rb.gemspec',
                   'README.rdoc',
                   'ext/definitions.h',
                   'ext/extconf.rb',
                   'ext/projrb.c',
                   'ext/vc/*.sln',
                   'ext/vc/*.vcxproj',
                   'lib/proj4.rb',
                   'test/*.rb']

  spec.test_files = Dir["test/test_*.rb"]

  spec.add_development_dependency('minitest')
  spec.add_development_dependency('rake-compiler')
  spec.add_development_dependency('rdoc')
end