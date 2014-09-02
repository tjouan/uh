module Holo
  class WM
    class Layout
      class Bar
        COLOR     = 'rgb:d7/00/5f'.freeze
        COLOR_ALT = 'rgb:ed/33/86'.freeze
        TAG_WIDTH = 15

        extend Forwardable
        def_delegators :@geo, :x, :y, :width, :height

        attr_reader :display, :geo, :window, :pixmap, :color, :color_alt

        def initialize(display, layout_geo)
          @display    = display
          @geo        = build_geo layout_geo
          @window     = display.create_subwindow geo
          @pixmap     = display.create_pixmap geo.width, geo.height
          @color      = display.color_by_name COLOR
          @color_alt  = display.color_by_name COLOR_ALT
        end

        def show
          window.show
          self
        end

        def update(layout)
          draw_background
          layout.tags.each_with_index do |t, i|
            draw_tag t, i, layout.current_tag?(t)
          end
          self
        end

        def blit
          pixmap.copy window
          self
        end


        private

        def build_geo(layout_geo)
          bar_height = display.font.height + 2

          Geo.new(
            layout_geo.x,
            layout_geo.height - bar_height,
            layout_geo.width,
            bar_height
          )
        end

        def draw_background
          pixmap.gc_black
          pixmap.draw_rect 0, 0, geo.width, geo.height
        end

        def draw_tag(tag, index, current)
          offset = index * TAG_WIDTH
          if current
            pixmap.gc_color color
            pixmap.draw_rect offset, 0, TAG_WIDTH, geo.height
          end
          pixmap.gc_white
          pixmap.draw_string offset + 5, display.font.ascent + 1, tag.id.to_s
        end
      end
    end
  end
end
