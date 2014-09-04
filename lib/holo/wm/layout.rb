module Holo
  class WM
    class Layout
      require 'forwardable'
      require 'holo/wm/layout/bar'
      require 'holo/wm/layout/client_list'
      require 'holo/wm/layout/col'
      require 'holo/wm/layout/col_list'
      require 'holo/wm/layout/screen'
      require 'holo/wm/layout/screen_list'
      require 'holo/wm/layout/tag'
      require 'holo/wm/layout/tag_list'

      extend Forwardable
      def_delegator :@screens, :current,  :current_screen
      def_delegator :@screens, :current?, :current_screen?
      def_delegator :current_screen, :current_tag, :current_tag
      def_delegator :current_screen, :suggest_geo, :suggest_geo
      def_delegator :current_tag, :current_col, :current_col
      def_delegator :current_tag, :current_client, :current_client

      attr_reader :display, :geo, :screens

      def initialize(display)
        @display  = display
        @screens  = ScreenList.new(display.screens) do |e|
          Screen.new(display, e)
        end
        update_screen_bars!
      end

      def to_s
        screens.inject('') do |m, screen|
          m << "%s%s\n" % [current_screen?(screen) ? '*' : ' ', screen]
          screen.tags.each do |tag|
            m << "  %s%s\n" % [screen.current_tag?(tag) ? '*' : ' ', tag]
            tag.cols.each do |col|
              m << "    %s%s\n" % [tag.current_col?(col) ? '*' : ' ', col]
              col.clients.each do |client|
                m << "      %s%s\n" % [
                  col.current_client?(client) ? '*' : ' ',
                  client
                ]
              end
            end
          end
          m
        end
      end

      def <<(client)
        current_screen << client
        focus_current_client
        update_screen_bars!
      end

      def remove(client)
        screens.remove client
        focus_current_client
        update_screen_bars!
      end

      def handle_screen_sel_next
        screens.sel_next
        focus_current_client
      end

      def handle_tag_sel(tag_id)
        current_screen.tag_sel tag_id
        focus_current_client
      end

      def handle_tag_set(tag_id)
        current_screen.tag_set tag_id
        focus_current_client
      end

      def handle_client_sel_prev
        current_col.client_sel_prev
      end

      def handle_client_sel_next
        current_col.client_sel_next
      end

      def handle_client_swap_prev
        current_col.client_swap_prev
      end

      def handle_client_swap_next
        current_col.client_swap_next
      end

      def handle_col_sel_prev
        current_tag.col_sel_prev
      end

      def handle_col_sel_next
        current_tag.col_sel_next
      end

      def handle_col_set_prev
        current_tag.col_set_prev
      end

      def handle_col_set_next
        current_tag.col_set_next
      end

      def handle_kill_current
        return unless current_client
        current_client.kill
      end


      private

      def focus_current_client
        if current_client
          current_client.focus
        else
          current_screen.bar.focus
        end
      end

      def update_screen_bars!
        screens.each { |e| e.update_bar! current_screen? e }
      end
    end
  end
end
