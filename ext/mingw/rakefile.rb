# We can't use Ruby's standard build procedures
# on Windows because the Ruby executable is
# built with VC++ while here we want to build
# with MingW.  So just roll our own...

require 'rake/clean'
require 'rbconfig'

RUBY_INCLUDE_DIR = Config::CONFIG["archdir"]
RUBY_BIN_DIR = Config::CONFIG["bindir"]
RUBY_LIB_DIR = Config::CONFIG["libdir"]
RUBY_SHARED_LIB = Config::CONFIG["LIBRUBY"]
RUBY_SHARED_DLL = RUBY_SHARED_LIB.gsub(/lib$/, 'dll')

EXTENSION_NAME = "proj4_ruby.#{Config::CONFIG["DLEXT"]}"
    
CLEAN.include('*.o')
CLOBBER.include(EXTENSION_NAME)

task :default => "projrb"

SRC = FileList['../*.c']
OBJ = SRC.collect do |file_name|
  File.basename(file_name).ext('o')
end

SRC.each do |srcfile|
  objfile = File.basename(srcfile).ext('o')
  file objfile => srcfile do
    command = "gcc -c -fPIC -O2 -Wall -mms-bitfields -o #{objfile} #{srcfile} -I#{RUBY_INCLUDE_DIR} -I/local/include"
    sh "sh -c '#{command}'" 
  end
end

file "projrb" => OBJ do
  command = "gcc -shared -o #{EXTENSION_NAME} #{OBJ} -lproj #{RUBY_BIN_DIR}/#{RUBY_SHARED_DLL} -L/local/lib" 
  sh "sh -c '#{command}'" 
end
