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

        attr_reader :display, :geo, :window

        def initialize(display, geo)
          @display  = display
          @geo      = geo
          @window   = display.create_subwindow geo
        end

        def show
          window.show
          self
        end

        def update(layout)
          puts '> BAR UPDATE! %s' % self
          self
        end

        def blit
          self
        end
      end
    end
  end
end
