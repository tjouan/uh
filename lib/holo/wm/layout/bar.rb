module Holo
  class WM
    class Layout
      class Bar
        HEIGHT = 13

        class << self
          def build(display, geo)
            bar_height = display.font.height + 2

            new(display, Geo.new(
              geo.x,
              geo.height - bar_height,
              geo.width,
              bar_height
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
          pixmap.gc_black
          pixmap.draw_rect 0, 0, geo.width, geo.height
          pixmap.gc_white
          pixmap.draw_string 1, display.font.ascent + 1, [
            tag_status(layout),
            "totoy éÉ ? ¤ ²…"
          ] * ' | '
          self
        end

        def blit
          pixmap.copy window
          self
        end


        private

        def tag_status(layout)
          layout.tags.sort_by(&:id).map do |tag|
            tag == layout.current_tag ? '[%s]' % tag.id : ' %s ' % tag.id
          end * ' '
        end
      end
    end
  end
end
