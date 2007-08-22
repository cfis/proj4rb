#should add an option for the proj.lib / proj.so + headers somewhere...
require 'mkmf'
have_library 'proj', 'pj_init'
create_makefile 'projrb'
