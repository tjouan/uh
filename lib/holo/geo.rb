module Holo
  class Geo < Struct.new(:x, :y, :width, :height)
    def initialize(*args)
      super
      %i[width height].each do |dimension|
        check_value dimension, send(dimension)
      end
    end

    def to_s
      '%sx%s+%s+%s' % [
        width   ? width.to_s  : ??,
        height  ? height.to_s : ??,
        x       ? x.to_s      : ??,
        y       ? y.to_s      : ??
      ]
    end

    def width=(value)
      check_value :width, value
      super value
    end

    def height=(value)
      check_value :height, value
      super value
    end


    private

    def check_value(name, value)
      fail ArgumentError, "invalid #{name.to_s}: #{value}" unless value > 0
    end
  end
end
