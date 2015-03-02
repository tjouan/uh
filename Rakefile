require 'rake/extensiontask'
require 'rake/testtask'

task default: :test

Rake::ExtensionTask.new('holo')

Rake::TestTask.new(test: :compile) do |t|
  t.libs      << 'lib' << 'test'
  t.pattern   = 'test/**/test_*.rb'
end

desc 'Execute pry console'
task console: :compile do
  require 'pry'
  require 'holo'
  require 'holo/wm'
  pry
end
