require 'mkmf'

fail 'libX11 is required' unless have_library 'X11'

create_makefile 'holo'
