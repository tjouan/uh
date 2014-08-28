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

        attr_reader :display, :geo, :window, :pixmap

        def initialize(display, geo)
          @display  = display
          @geo      = geo
          @window   = display.create_subwindow geo
          @pixmap   = display.create_pixmap geo.width, geo.height
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
          pixmap.copy window
          self
        end
      end
    end
  end
end
