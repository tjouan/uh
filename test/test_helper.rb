#require 'minitest/parallel'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'uh'

class Minitest::Test
  # FIXME: SpecReporter output is incorrect with pretty diffs or parallel tests
  #make_my_diffs_pretty!
  #parallelize_me!
end

class UhSpec < Minitest::Spec
  class << self
    alias context describe
  end
end

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
