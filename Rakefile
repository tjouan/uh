require 'rake/extensiontask'
require 'rake/testtask'

task default: :test

Rake::ExtensionTask.new('uh')

Rake::TestTask.new(test: :compile) do |t|
  t.libs      << 'lib' << 'test'
  t.pattern   = 'test/**/test_*.rb'
end
