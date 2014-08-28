module Holo
  class WM
    class Layout
      class Bar
        HEIGHT = 13

        class << self
          def build(display, geo)
            new(display, Geo.new(
              geo.x,
              geo.height - HEIGHT,
              geo.width,
              HEIGHT
            ))
          end
        end

        attr_reader :display, :geo

        def initialize(display, geo)
          @display  = display
          @geo      = geo
        end

        def update(layout)
          puts '> BAR UPDATE! %s' % self
        end
      end
    end
  end
end
