require 'rake/extensiontask'

Rake::ExtensionTask.new('holo')


task default: :compile

desc 'Execute pry console'
task console: :compile do
  require 'pry'
  require 'holo'
  require 'holo/wm'
  pry
end
