require 'rake/extensiontask'


task default: :demo

Rake::ExtensionTask.new('holo')

desc 'Execute holowm in a Xephyr X server'
task :demo do
  xephyr = '/usr/local/bin/Xephyr :42 -ac -br -noreset -screen 1024x400'
  sh "xinit ./bin/xinitrc -- #{xephyr}"
end

desc 'Execute pry console with holowm required'
task :console do
  require 'holo'
  require 'holo/wm'
  pry
end

desc 'Build holowm'
task build: %i[clean compile]
