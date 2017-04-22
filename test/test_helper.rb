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
  def described_class
    self.class.const_get self.class.name.sub /::(?:\.|#).+\z/, ''
  end
end

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

unless ENV.key? 'UHTEST_CI'
  ENV['DISPLAY'] = ':42'

  xvfb_pid = fork do
    exec *%w[Xvfb -ac :42 -screen 0 640x480x24]
  end

  Minitest.after_run do
    Process.kill 'TERM', xvfb_pid
    Process.wait xvfb_pid
  end
end
