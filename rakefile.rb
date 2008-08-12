require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/clean'
require 'ftools'

task :default => :test

CLOBBER.include('pkg/*', 'proj4rb-doc/**/*', 'lib/*.so', 'lib/*.bundle', 'lib/*.dll', 'ext/*.o', 'ext/*.so', 'ext/*.bundle', 'ext/*.dll', 'ext/Makefile', 'ext/mkmf.log')

desc "Create Makefile"
file 'ext/Makefile' => ['ext/extconf.rb'] do
    sh 'cd ext; ruby extconf.rb'
end

desc "Build from C library"
task :build => ['ext/Makefile', 'ext/projrb.c'] do
    sh 'cd ext; make'
    # Try the different suffixes for Linux, Mac OS X, or Windows shared libraries and put the one found into lib dir
    ['so', 'bundle', 'dll'].each do |suffix|
        if File.exists?('ext/projrb.' + suffix)
            puts "Copying 'ext/projrb.#{suffix}' to lib/"
            File.copy('ext/projrb.' + suffix, 'lib/projrb.' + suffix)
        end
    end
end

desc "Run the tests"
Rake::TestTask::new do |t|
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
end

desc "Generate the documentation"
Rake::RDocTask::new do |rdoc|
    rdoc.rdoc_dir = 'proj4rb-doc/'
    rdoc.title    = "Proj4rb Documentation"
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('ext/*.c', 'lib/proj4.rb')
end

default_spec = Gem::Specification::new do |s|
    s.name = 'proj4rb'
    s.version = "0.2.2"
    s.summary = "Ruby bindings for the Proj.4 Carthographic Projection library"
    s.description = <<EOF
    Proj4rb is a ruby binding for the Proj.4 Carthographic Projection library, that supports conversions between a very large number of geographic coordinate systems and datums.
EOF
    s.author = 'Guilhem Vellut'
    s.email = 'guilhem.vellut@gmail.com'
    s.homepage = 'http://proj4rb.rubyforge.org/'
    s.rubyforge_project = 'proj4rb'
    s.required_ruby_version = '>= 1.8.4'
    
    s.platform = Gem::Platform::RUBY
    s.requirements << 'Proj.4 C library'
    s.require_path = 'lib'
    s.extensions = ["ext/extconf.rb"]
    s.files = FileList["lib/**/*.rb", "lib/**/*.dll","lib/**/*.so","lib/**/*.bundle","example/**/*.rb","ext/extconf.rb","ext/*.h","ext/*.c","test/**/*.rb", "README","MIT-LICENSE","rakefile.rb"]
    s.test_files = FileList['test/test*.rb']
    
    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]
    s.rdoc_options.concat ['--main',  'README']
end

desc "Package the library as a gem"
Rake::GemPackageTask.new(default_spec) do |pkg|
    #pkg.need_zip = true
    pkg.need_tar = true
end


# ------- Windows Package ----------
# Windows specification
SO_NAME = "projrb.so"

win_spec = default_spec.clone
win_spec.extensions = []
win_spec.platform = Gem::Platform::CURRENT
win_spec.files += ["lib/#{SO_NAME}"]

desc "Create Windows Gem"
task :create_win32_gem do
  # Copy the win32 extension built by MingW - easier to install
  # since there are no dependencies of msvcr80.dll
  current_dir = File.expand_path(File.dirname(__FILE__))
  source = File.join(current_dir, "mingw", SO_NAME)
  target = File.join(current_dir, "lib", SO_NAME)
  cp(source, target)

  # Create the gem, then move it to pkg
  Gem::Builder.new(win_spec).build
  gem_file = "#{win_spec.name}-#{win_spec.version}-#{win_spec.platform}.gem"
  mv(gem_file, "pkg/#{gem_file}")

  # Remove win extension from top level directory  
  rm(target)
end


task :package => :create_win32_gem
