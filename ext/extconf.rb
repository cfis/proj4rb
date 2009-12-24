require 'mkmf'

dir_config('proj')

if not have_header('proj_api.h')
  raise('Cannot find proj_api.h header')
end

if not have_library('proj', 'pj_init')
  raise('Cannot find proj4 library')
end

create_makefile 'proj4_ruby'
