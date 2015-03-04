require 'uh/uh'
require 'uh/display'
require 'uh/drawable'
require 'uh/events'
require 'uh/font'
require 'uh/geo'
require 'uh/pixmap'
require 'uh/screen'
require 'uh/version'
require 'uh/window'

module Uh
  Error               = Class.new(StandardError)
  RuntimeError        = Class.new(RuntimeError)
  ArgumentError       = Class.new(Error)
  OtherWMRunningError = Class.new(RuntimeError)

  KEY_MODIFIERS = {
    shift:  1 << 0,
    lock:   1 << 1,
    ctrl:   1 << 2,
    mod1:   1 << 3,
    mod2:   1 << 4,
    mod3:   1 << 5,
    mod4:   1 << 6,
    mod5:   1 << 7
  }.freeze
end
