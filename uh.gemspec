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
  s.test_files  = s.files.grep /\A(spec|features)\//
  s.executables = s.files.grep(/\Abin\//) { |f| File.basename(f) }


  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'minitest',            '~> 5.5'
  s.add_development_dependency 'minitest-reporters',  '~> 1.0'
end
