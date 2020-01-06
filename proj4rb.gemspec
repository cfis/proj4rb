Gem::Specification.new do |spec|
  spec.name = 'proj4rb'
  spec.version = '2.1.0'
  spec.summary = 'Ruby bindings for the Proj.4 Carthographic Projection library'
  spec.description = <<-EOF
    Proj4rb is a ruby binding for the Proj.4 Carthographic Projection library, that supports conversions between a very large number of geographic coordinate systems and datumspec.
  EOF
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Guilhem Vellut', 'Jochen Topf', 'Charlie Savage']
  spec.homepage = 'https://github.com/cfis/proj4rb'
  spec.required_ruby_version = '>= 2.4.1'
  spec.license = 'MIT'

  spec.requirements << 'Proj (Proj4) Library'
  spec.require_path = 'lib'
  spec.files = Dir['ChangeLog',
                   'Gemfile',
                   'MIT-LICENSE',
                   'proj4rb.gemspec',
                   'Rakefile',
                   'README.rdoc',
                   'lib/**/*.rb',
                   'test/*.rb']

  spec.test_files = Dir["test/test_*.rb"]

  spec.add_dependency "ffi"

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('minitest')
  spec.add_development_dependency('yard')
end