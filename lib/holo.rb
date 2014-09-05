module Holo
  require 'holo.so'
  require 'holo/display'
  require 'holo/drawable'
  require 'holo/events'
  require 'holo/font'
  require 'holo/geo'
  require 'holo/pixmap'
  require 'holo/screen'
  require 'holo/window'

  Error               = Class.new(StandardError)
  RuntimeError        = Class.new(RuntimeError)
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
