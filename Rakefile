require 'rake/extensiontask'


task default: :demo

Rake::ExtensionTask.new('holo')

desc 'Execute holowm in a Xephyr X server'
task :demo do
  #ENV['RUBYOPT'] = '-Ilib'
  xephyr = '/usr/local/bin/Xephyr :42 -ac -br -origin 384,0 -screen 1024x400'
  sh "xinit ./bin/xinitrc -- #{xephyr}"
end
