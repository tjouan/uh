module Holo
  class WM
    class Layout
      class Bar
        COLOR             = 'rgb:d7/00/5f'.freeze
        COLOR_ALT         = 'rgb:82/00/3a'.freeze
        TAG_WIDTH         = 15
        COL_WIDGET_HEIGHT = 2

        extend Forwardable
        def_delegators :@geo, :x, :y, :width, :height

        attr_reader :display, :geo, :window, :pixmap, :color, :color_alt
        attr_writer :active

        def initialize(display, screen_geo)
          @display    = display
          @geo        = build_geo screen_geo
          @window     = display.create_subwindow geo
          @pixmap     = display.create_pixmap geo.width, geo.height
          @color      = display.color_by_name COLOR
          @color_alt  = display.color_by_name COLOR_ALT
        end

        def active?
          !!@active
        end

        def show
          window.show
          self
        end

        def focus
          window.focus
          self
        end

        def update(tags, current_tag)
          draw_background
          draw_cols current_tag.cols, current_tag.current_col
          draw_tags tags, current_tag
          self
        end

        def blit
          pixmap.copy window
          self
        end


        private

        def build_geo(layout_geo)
          bar_height = text_line_height * 2 + COL_WIDGET_HEIGHT + 1

          Geo.new(
            layout_geo.x,
            layout_geo.height - bar_height,
            layout_geo.width,
            bar_height
          )
        end

        def active_color
          active? ? color : color_alt
        end

        def text_line_height
          display.font.height + 2
        end

        def col_widget_y
          0
        end

        def col_line_y
          col_widget_y + COL_WIDGET_HEIGHT
        end

        def layout_line_y
          col_line_y + text_line_height + 1
        end

        def draw_background
          pixmap.gc_black
          pixmap.draw_rect 0, 0, geo.width, geo.height
        end

        def draw_cols(cols, current_col)
          cols.each do |col|
            draw_col col, col == current_col
          end
        end

        def draw_col(col, current)
          pixmap.gc_color current ? active_color : color_alt
          pixmap.draw_rect col_x(col) + 1, col_widget_y,
            col.geo.width - 1, COL_WIDGET_HEIGHT
          pixmap.gc_white
          text_y = col_line_y + display.font.ascent + 1
          pixmap.draw_string col_x(col) + 2, text_y, '%d/%d %s' % [
            col.current_client_index,
            col.clients_count,
            col.current_client.to_s
          ]
        end

        def col_x(col)
          col.geo.x - x
        end

        def draw_tags(tags, current_tag)
          tags.each_with_index do |t, i|
            draw_tag t, i, t == current_tag
          end
        end

        def draw_tag(tag, index, current)
          offset = index * TAG_WIDTH
          if current
            pixmap.gc_color active_color
            pixmap.draw_rect offset, layout_line_y, TAG_WIDTH, text_line_height
          end
          pixmap.gc_white
          text_y = layout_line_y + display.font.ascent + 1
          pixmap.draw_string offset + 5, text_y, tag.id.to_s
        end
      end
    end
  end
end
