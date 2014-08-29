module Holo
  class Geo < Struct.new(:x, :y, :width, :height)
    def to_s
      '%dx%d+%d+%d' % [width, height, x, y]
    end
  end
end
