require 'mkmf'

fail 'libX11 is required'       unless have_library 'X11'
fail 'libXinerama is required'  unless have_library 'Xinerama'

$CFLAGS << ' -std=c99 -Wall'
if %w[DEBUG VALGRIND].any? { |e| ENV.key? e }
  $CFLAGS.gsub! /-O\d\s/, '-g '
end

create_makefile 'uh/uh'
