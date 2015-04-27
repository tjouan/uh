require 'mkmf'

%w[X11 Xinerama].each { |e| fail "lib#{e} is required" unless have_library e }

$CFLAGS << ' -std=c99 -Wall'
if %w[DEBUG VALGRIND].any? { |e| ENV.key? e }
  $CFLAGS.gsub! /-O\d\s/, '-g '
end

create_makefile 'uh/uh'
