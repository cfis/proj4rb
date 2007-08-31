require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/clean'

task :default => :test

CLOBBER.include('pkg/*', 'proj4rb-doc/**/*', 'lib/*.so', 'lib/*.bundle', 'lib/*.dll', 'src/*.o', 'src/*.so', 'src/*.bundle', 'src/*.dll', 'src/Makefile', 'src/mkmf.log')

desc "Create Makefile"
file 'src/Makefile' => ['src/extconf.rb'] do
    sh 'cd src; ruby extconf.rb'
end

desc "Build from C library"
task :build => ['src/Makefile', 'src/projrb.c'] do
    sh 'cd src; make'
    # Try the different suffixes for Linux, Mac OS X, or Windows shared libraries and put the one found into lib dir
    ['so', 'bundle', 'dll'].each do |suffix|
        if File.exists?('src/projrb.' + suffix)
            puts "Copying 'src/projrb.#{suffix}' to lib/"
            File.copy('src/projrb.' + suffix, 'lib/projrb.' + suffix)
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
    rdoc.rdoc_files.include('src/**/*.c', 'lib/proj4.rb')
end

spec = Gem::Specification::new do |s|
    s.platform = Gem::Platform::CURRENT

    s.name = 'proj4rb'
    s.version = "0.2.1"
    s.summary = "Ruby bindings for the Proj.4 Carthographic Projection library"
    s.description = <<EOF
    Proj4rb is a ruby binding for the Proj.4 Carthographic Projection library, that supports conversions between a very large number of geographic coordinate systems and datums.
EOF
    s.author = 'Guilhem Vellut'
    s.email = 'guilhem.vellut@gmail.com'
    s.homepage = 'http://thepochisuperstarmegashow.com'
    s.rubyforge_project = 'proj4rb'
    
    s.requirements << 'Proj.4 C library'
    s.require_path = 'lib'
    s.files = FileList["lib/**/*.rb", "lib/**/*.dll","lib/**/*.so","lib/**/*.bundle","example/**/*.rb","src/extconf.rb","src/**/*.h","src/**/*.c","test/**/*.rb", "README","MIT-LICENSE","rakefile.rb"]
    s.test_files = FileList['test/test*.rb']

    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]
    s.rdoc_options.concat ['--main',  'README']
end

desc "Package the library as a gem"
Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
end

