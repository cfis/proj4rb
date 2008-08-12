require 'mkmf'

# help with compiling on Mac OS X
$CFLAGS += " -I/sw/include"
$LDFLAGS += " -L/sw/lib"

have_library 'proj', 'pj_init'
create_makefile 'proj4_ruby'
