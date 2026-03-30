Gem::Specification.new do |spec|
  spec.name = 'proj4rb'
  spec.version = '5.0.0'
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
  spec.files = Dir['CHANGELOG.md',
                   'Gemfile',
                   'MIT-LICENSE',
                   'proj4rb.gemspec',
                   'Rakefile',
                   'README.md',
                   'lib/**/*.rb',
                   'test/*.rb']

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/cfis/proj4rb',
    'changelog_uri' => 'https://github.com/cfis/proj4rb/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://cfis.github.io/proj4rb/'
  }

  spec.add_dependency "ffi", ">=1.17.4"

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('minitest')
  spec.add_development_dependency('yard')
end