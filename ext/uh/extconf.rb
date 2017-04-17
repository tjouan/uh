require 'mkmf'

%w[X11 Xinerama].each { |e| fail "lib#{e} is required" unless have_library e }

$CFLAGS << ' -std=c99 -Wall'
if ENV.key? 'DEBUG'
  $CFLAGS.gsub! /-O\d\s/, '-g '
end

create_makefile 'uh/uh'
