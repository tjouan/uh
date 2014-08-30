module Holo
  class Geo < Struct.new(:x, :y, :width, :height)
    def to_s
      '%sx%s+%s+%s' % [
        width   ? width.to_s  : ??,
        height  ? height.to_s : ??,
        x       ? x.to_s      : ??,
        y       ? y.to_s      : ??
      ]
    end
  end
end
