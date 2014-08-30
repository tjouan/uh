module Holo
  class WM
    class Layout
      class Bar
        HEIGHT    = 13
        TAG_WIDTH = 10

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
          draw_background
          sort_tags(layout.tags).each_with_index do |t, i|
            draw_tag t, i, layout.current_tag?(t)
          end
          self
        end

        def blit
          pixmap.copy window
          self
        end


        private

        def sort_tags(tags)
          tags.sort_by(&:id)
        end

        def draw_background
          pixmap.gc_black
          pixmap.draw_rect 0, 0, geo.width, geo.height
        end

        def draw_tag(tag, index, current)
          offset = index * TAG_WIDTH
          if current
            pixmap.gc_white
            pixmap.draw_rect offset, 0, TAG_WIDTH, geo.height
            pixmap.gc_black
          else
            pixmap.gc_white
          end
          pixmap.draw_string offset + 2, display.font.ascent + 1, tag.id.to_s
        end
      end
    end
  end
end
