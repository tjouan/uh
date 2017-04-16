require 'rake/extensiontask'
require 'rake/testtask'

task default: :test

Rake::ExtensionTask.new('uh') do |t|
  t.lib_dir = 'lib/uh'
end

Rake::TestTask.new(test: :compile) do |t|
  t.libs      << 'lib' << 'test'
  t.pattern   = 'test/**/test_*.rb'
  t.warning   = false
end
