require 'uh/uh'
require 'uh/display'
require 'uh/events'
require 'uh/events/event'
require 'uh/font'
require 'uh/geo'
require 'uh/geo_accessors'
require 'uh/screen'
require 'uh/version'
require 'uh/window'

module Uh
  CURSORS = {
    num_glyphs: 154,
    x_cursor: 0,
    arrow: 2,
    based_arrow_down: 4,
    based_arrow_up: 6,
    boat: 8,
    bogosity: 10,
    bottom_left_corner: 12,
    bottom_right_corner: 14,
    bottom_side: 16,
    bottom_tee: 18,
    box_spiral: 20,
    center_ptr: 22,
    circle: 24,
    clock: 26,
    coffee_mug: 28,
    cross: 30,
    cross_reverse: 32,
    crosshair: 34,
    diamond_cross: 36,
    dot: 38,
    dotbox: 40,
    double_arrow: 42,
    draft_large: 44,
    draft_small: 46,
    draped_box: 48,
    exchange: 50,
    fleur: 52,
    gobbler: 54,
    gumby: 56,
    hand1: 58,
    hand2: 60,
    heart: 62,
    icon: 64,
    iron_cross: 66,
    left_ptr: 68,
    left_side: 70,
    left_tee: 72,
    leftbutton: 74,
    ll_angle: 76,
    lr_angle: 78,
    man: 80,
    middlebutton: 82,
    mouse: 84,
    pencil: 86,
    pirate: 88,
    plus: 90,
    question_arrow: 92,
    right_ptr: 94,
    right_side: 96,
    right_tee: 98,
    rightbutton: 100,
    rtl_logo: 102,
    sailboat: 104,
    sb_down_arrow: 106,
    sb_h_double_arrow: 108,
    sb_left_arrow: 110,
    sb_right_arrow: 112,
    sb_up_arrow: 114,
    sb_v_double_arrow: 116,
    shuttle: 118,
    sizing: 120,
    spider: 122,
    spraycan: 124,
    star: 126,
    target: 128,
    tcross: 130,
    top_left_arrow: 132,
    top_left_corner: 134,
    top_right_corner: 136,
    top_side: 138,
    top_tee: 140,
    trek: 142,
    ul_angle: 144,
    umbrella: 146,
    ur_angle: 148,
    watch: 150,
    xterm: 152,
  }

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

  class << self
    def open
      display = Display.new.tap &:open
      begin
        yield display
      ensure
        display.close
      end
    end
  end
end
