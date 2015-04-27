#require 'minitest/parallel'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'headless'
require 'uh'

class Minitest::Test
  # FIXME: SpecReporter output is incorrect with pretty diffs or parallel tests
  #make_my_diffs_pretty!
  #parallelize_me!
end

class UhSpec < Minitest::Spec
  before { Headless.new.start }

  def described_class
    self.class.const_get self.class.name.sub /::(?:\.|#).+\z/, ''
  end
end

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
