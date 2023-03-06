Gem::Specification.new do |spec|
  spec.name = 'proj4rb'
  spec.version = '3.0.0'
  spec.summary = 'Ruby bindings for the Proj coordinate transformation library'
  spec.description = <<-EOF
    Ruby bindings for the Proj coordinate transformation library
  EOF
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Guilhem Vellut', 'Jochen Topf', 'Charlie Savage']
  spec.homepage = 'https://github.com/cfis/proj4rb'
  spec.required_ruby_version = '>= 2.7'
  spec.license = 'MIT'

  spec.requirements << 'Proj Library'
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