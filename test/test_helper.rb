#require 'minitest/parallel'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'holo'

class Minitest::Test
  # FIXME: SpecReporter output is incorrect with pretty diffs or parallel tests
  #make_my_diffs_pretty!
  #parallelize_me!
end

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
