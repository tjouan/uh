require File.expand_path('../lib/uh/version', __FILE__)

Gem::Specification.new do |s|
  s.name    = 'uh'
  s.version = Uh::VERSION.dup
  s.summary = 'Xlib simplified toolkit'
  s.description = s.name
  s.homepage = 'https://rubygems.org/gems/uh'

  s.authors = 'Thibault Jouan'
  s.email   = 'tj@a13.fr'

  s.files       = `git ls-files`.split $/
  s.test_files  = s.files.grep /\Atest\//

  s.extensions  = %w[ext/uh/extconf.rb]


  s.add_development_dependency 'rake',                '~> 10.4'
  s.add_development_dependency 'rake-compiler',       '~> 0.9'
  s.add_development_dependency 'minitest',            '~> 5.5'
  s.add_development_dependency 'minitest-reporters',  '~> 1.0'
end
