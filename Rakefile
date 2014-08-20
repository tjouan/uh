task :default => [:demo]

desc 'Execute holowm in a Xephyr X server'
task :demo do
  display = ':42'
  pid = fork do
    #exec "Xvfb #{display} -ac -br -screen 0 1024x400x24"
    exec "Xephyr #{display} -ac -br -screen 1024x400"
  end
  ENV['DISPLAY'] = display
  # FIXME: should select()/wait on server socket?
  # /tmp/.X11-unix/X42
  sleep 0.5
  sh 'ruby -Ilib -I. -rholo bin/holowm'
  Process.kill 'TERM', pid
  begin
    Process.wait pid
  rescue Errno::ECHILD
  end
end
