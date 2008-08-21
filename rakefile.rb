require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/clean'
require 'date'
require 'ftools'

CLOBBER.include('pkg/*', 'proj4rb-doc/**/*', 'lib/*.so', 'lib/*.bundle', 'lib/*.dll', 'ext/*.o', 'ext/*.so', 'ext/*.bundle', 'ext/*.dll', 'ext/Makefile', 'ext/mkmf.log')

desc "Create Makefile"
file 'ext/Makefile' => ['ext/extconf.rb'] do
    sh 'cd ext; ruby extconf.rb'
end

desc "Build from C library"
task :build => ['ext/Makefile', 'ext/projrb.c'] do
    sh 'cd ext; make'
end

# ------- Default Package ----------
FILES = FileList[
  'rakefile.rb',
  'README',
  'MIT-LICENSE',
  'data/**/*',
  'doc/**/*',
  'example/**/*',
  'ext/*',
  'ext/mingw/rakefile.rb',
  'ext/vc/*.sln',
  'ext/vc/*.vcproj',
  'lib/**/*.rb'
]

# Default GEM Specification
default_spec = Gem::Specification::new do |s|
    s.name = 'proj4rb'
    s.version = "0.3.0"
    s.summary = "Ruby bindings for the Proj.4 Carthographic Projection library"
    s.description = <<-EOF
      Proj4rb is a ruby binding for the Proj.4 Carthographic Projection library, that supports conversions between a very large number of geographic coordinate systems and datums.
    EOF
    s.author = 'Guilhem Vellut'
    s.email = 'guilhem.vellut@gmail.com'
    s.homepage = 'http://proj4rb.rubyforge.org/'
    s.rubyforge_project = 'proj4rb'
    s.required_ruby_version = '>= 1.8.4'
    s.date = DateTime.now
    
    s.platform = Gem::Platform::RUBY
    s.requirements << 'Proj.4 C library'
    s.require_path = 'lib'
    s.extensions = ["ext/extconf.rb"]
    s.files = FILES.to_a
    s.test_files = FileList['test/test*.rb']
    
    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]
    s.rdoc_options.concat ['--main',  'README']
end

desc "Package the library as a gem"
Rake::GemPackageTask.new(default_spec) do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
end


# ------- Windows Package ----------
binaries = (FileList['ext/mingw/*.so',
                     'ext/mingw/*.dll*'])

win_spec = default_spec.clone
win_spec.extensions = []
win_spec.platform = Gem::Platform::CURRENT
win_spec.files += binaries.map {|binaryname| "lib/#{File.basename(binaryname)}"}

desc "Create Windows Gem"
task :create_win32_gem do
  # Copy the win32 extension built by MingW - easier to install
  # since there are no dependencies of msvcr80.dll
  current_dir = File.expand_path(File.dirname(__FILE__))

  binaries.each do |binaryname|
    target = File.join(current_dir, 'lib', File.basename(binaryname))
    cp(binaryname, target)
  end
  
  # Create the gem, then move it to admin/pkg
  Gem::Builder.new(win_spec).build
  gem_file = "#{win_spec.name}-#{win_spec.version}-#{win_spec.platform}.gem"
  mv(gem_file, "pkg/#{gem_file}")

  # Remove win extension from top level directory  
  binaries.each do |binaryname|
    target = File.join(current_dir, 'lib', File.basename(binaryname))
    rm(target)
  end
end


# ---------  Test Task ---------
Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib"
end

# ---------  RDoc Documentation ---------
desc "Generate rdoc documentation"
Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.title    = "Proj4rb Documentation"
  # Show source inline with line numbers
  rdoc.options << "--inline-source" << "--line-numbers"
  # Make the readme file the start page for the generated html
  rdoc.options << '--main' << 'README'
  rdoc.rdoc_files.include('doc/*.rdoc',
                          'ext/**/*.c',
                          'lib/**/*.rb',
                          'README',
                          'MIT-LICENSE')
end

task :default => :package

if RUBY_PLATFORM.match(/win32/)
  task :package => :create_win32_gem
end
