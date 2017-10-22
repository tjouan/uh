require File.expand_path '../lib/uh/version', __FILE__

Gem::Specification.new do |s|
  s.name        = 'uh'
  s.version     = Uh::VERSION.dup
  s.summary     = 'Xlib simplified toolkit'
  s.license     = 'BSD-3-Clause'
  s.homepage    = 'https://rubygems.org/gems/uh'

  s.authors     = 'Thibault Jouan'
  s.email       = 'tj@a13.fr'

  s.files       = `git ls-files ext lib`.split $/
  s.extra_rdoc_files = %w[README.md]

  s.extensions  = %w[ext/uh/extconf.rb]


  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler',       '~> 1.0'
  s.add_development_dependency 'minitest',            '~> 5.6'
  s.add_development_dependency 'minitest-reporters',  '~> 1.0'
end
