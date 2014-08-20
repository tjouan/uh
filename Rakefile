require 'rake/extensiontask'


task default: :demo

Rake::ExtensionTask.new('holo')

desc 'Execute holowm in a Xephyr X server'
task :demo do
  display = ':42'
  pid = fork do
    $stderr.reopen '/dev/null'
    #exec "Xvfb #{display} -ac -br -screen 0 1024x400x24"
    exec "Xephyr #{display} -ac -br -screen 1024x400"
  end
  ENV['DISPLAY'] = display
  ENV['RUBYOPT'] = '-Ilib'
  sh 'bundle exec bin/holowm'
  Process.kill 'TERM', pid
  begin
    Process.wait pid
  rescue Errno::ECHILD
  end
end
