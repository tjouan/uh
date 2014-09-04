module Holo
  class WM
    class Layout
      require 'forwardable'
      require 'holo/wm/layout/bar'
      require 'holo/wm/layout/client_list'
      require 'holo/wm/layout/col'
      require 'holo/wm/layout/col_list'
      require 'holo/wm/layout/tag'
      require 'holo/wm/layout/tag_list'

      extend Forwardable
      def_delegator :@tags, :current, :current_tag
      def_delegator :@tags, :current?, :current_tag?
      def_delegator :current_tag, :current_client, :current_client

      attr_reader :display, :geo, :tags, :bar

      def initialize(display)
        @display  = display
        @geo      = display.screens.first.geo
        @bar      = Bar.new(display, geo).show
        @tags     = TagList.new(geo_for_new_tag)
        update_bar!
      end

      def to_s
        tags.inject('') do |m, tag|
          m << "%s%s\n" % [current_tag?(tag) ? '*' : ' ', tag]
          tag.cols.each do |col|
            m << "  %s%s\n" % [tag.current_col?(col) ? '*' : ' ', col]
            col.clients.each do |client|
              m << "    %s%s\n" % [
                col.current_client?(client) ? '*' : ' ',
                client
              ]
            end
          end
          m
        end
      end

      def <<(client)
        current_tag << client
        focus_current_client
        update_bar!
      end

      def remove(client)
        tags.remove_client client
        focus_current_client
        update_bar!
      end

      def suggest_geo_for_client
        current_tag.current_col_geo
      end

      def handle_tag_sel(tag_id)
        return unless current_tag.id != tag_id
        current_tag.hide
        tags.sel(tag_id).show
        focus_current_client
        update_bar!
      end

      def handle_tag_set(tag_id)
        return unless current_tag.id != tag_id && current_client
        current_client.hide
        tags.set tag_id, current_client.hide
        focus_current_client
        update_bar!
      end

      def handle_client_sel_prev
        current_tag.current_col.client_sel_prev
        update_bar!
      end

      def handle_client_sel_next
        current_tag.current_col.client_sel_next
        update_bar!
      end

      def handle_client_swap_prev
        current_tag.current_col.client_swap_prev
        update_bar!
      end

      def handle_client_swap_next
        current_tag.current_col.client_swap_next
        update_bar!
      end

      def handle_col_sel_prev
        current_tag.col_sel_prev
        update_bar!
      end

      def handle_col_sel_next
        current_tag.col_sel_next
        update_bar!
      end

      def handle_col_set_prev
        current_tag.col_set_prev
        update_bar!
      end

      def handle_col_set_next
        current_tag.col_set_next
        update_bar!
      end

      def handle_kill_current
        return unless current_client
        current_client.kill
        update_bar!
      end


      private

      def geo_for_new_tag
        geo.dup.tap { |o| o.height -= bar.height }
      end

      def focus_current_client
        current_client and current_client.focus
      end

      def update_bar!
        bar.update(self).blit
      end
    end
  end
end
