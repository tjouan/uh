module Holo
  class Geo
    attr_accessor :x, :y, :width, :height

    def initialize(x = 0, y = 0, width = 484, height = 300)
      @x      = x
      @y      = y
      @width  = width
      @height = height
    end

    def to_s
      '%dx%d+%d+%d' % [width, height, x, y]
    end
  end
end
