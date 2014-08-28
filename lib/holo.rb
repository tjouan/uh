module Holo
  require 'holo.so'
  require 'holo/display'
  require 'holo/geo'
  require 'holo/pixmap'
  require 'holo/screen'
  require 'holo/window'
  require 'pry'

  # FIXME: ruby errors defined in C ext should be considered
  Error               = Class.new(StandardError)
  RuntimeError        = Class.new(RuntimeError)
  OtherWMRunningError = Class.new(RuntimeError)


  # Input Event Masks. Used as event-mask window attribute and as arguments
  # to Grab requests. Not to be confused with event names.
  NO_EVENT_MASK               = 0
  KEY_PRESS_MASK              = 1 <<  0
  KEY_RELEASE_MASK            = 1 <<  1
  BUTTON_PRESS_MASK           = 1 <<  2
  BUTTON_RELEASE_MASK         = 1 <<  3
  ENTER_WINDOW_MASK           = 1 <<  4
  LEAVE_WINDOW_MASK           = 1 <<  5
  POINTER_MOTION_MASK         = 1 <<  6
  POINTER_MOTION_HINT_MASK    = 1 <<  7
  BUTTON1_MOTION_MASK         = 1 <<  8
  BUTTON2_MOTION_MASK         = 1 <<  9
  BUTTON3_MOTION_MASK         = 1 << 10
  BUTTON4_MOTION_MASK         = 1 << 11
  BUTTON5_MOTION_MASK         = 1 << 12
  BUTTON_MOTION_MASK          = 1 << 13
  KEYMAP_STATE_MASK           = 1 << 14
  EXPOSURE_MASK               = 1 << 15
  VISIBILITY_CHANGE_MASK      = 1 << 16
  STRUCTURE_NOTIFY_MASK       = 1 << 17
  RESIZE_REDIRECT_MASK        = 1 << 18
  SUBSTRUCTURE_NOTIFY_MASK    = 1 << 19
  SUBSTRUCTURE_REDIRECT_MASK  = 1 << 20
  FOCUS_CHANGE_MASK           = 1 << 21
  PROPERTY_CHANGE_MASK        = 1 << 22
  COLORMAP_CHANGE_MASK        = 1 << 23
  OWNER_GRAB_BUTTON_MASK      = 1 << 24

  # Key masks. Used as modifiers to GrabButton and GrabKey, results of
  # QueryPointer, state in various key-, mouse-, and button-related events.
  MODIFIERS   = {
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
