module Holo
  class WM
    class Layout
      require 'forwardable'
      require 'holo/wm/layout/bar'
      require 'holo/wm/layout/col'
      require 'holo/wm/layout/tag'
      require 'holo/wm/layout/tag_list'

      attr_reader :display, :geo, :tags, :current_tag, :bar

      def initialize(display)
        @display      = display
        @geo          = display.screens.first.geo
        @bar          = Bar.new(display, geo).show
        @tags         = TagList.new(Tag.new(1, geo_for_new_tag))
        @current_tag  = tags.first
        update_bar!
      end

      def to_s
        tags.inject('') do |m, tag|
          m << "%s%s\n" % [tag == current_tag ? '*' : ' ', tag]
          tag.cols.each do |col|
            m << "  %s%s\n" % [col == tag.current_col ? '*' : ' ', col]
            col.clients.each do |client|
              m << "    %s%s\n" % [client == col.current_client ? '*' : ' ', client]
            end
          end
          m
        end
      end

      def <<(client)
        current_tag << client
        client.show.focus
      end

      def remove(client)
        tags.each { |e| e.remove client }
        focus_current_client
      end

      def suggest_geo
        current_tag.current_col.geo
      end

      def current_tag?(tag)
        current_tag == tag
      end

      def handle_tag_sel(tag_id)
        return unless current_tag.id != tag_id
        current_tag.hide
        @current_tag = find_or_create_tag(tag_id).show
        focus_current_client
        update_bar!
      end

      def handle_tag_set(tag_id)
        return unless current_tag.id != tag_id && current_client
        client = current_tag.current_client
        client.hide
        current_tag.remove client
        find_or_create_tag(tag_id) << client
        focus_current_client
        update_bar!
      end

      def handle_sel_prev
        current_tag.sel_prev
      end

      def handle_sel_next
        current_tag.sel_next
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
        current_client.kill if current_client
      end


      private

      def geo_for_new_tag
        geo.dup.tap { |o| o.height -= bar.height }
      end

      def current_client
        current_tag.current_client
      end

      def focus_current_client
        current_client and current_client.focus
      end

      def find_or_create_tag(id)
        tags << tag = Tag.new(id, geo_for_new_tag) unless tag = tags.find { |e| e.id == id }
        tag
      end

      def update_bar!
        bar.update(self).blit
      end
    end
  end
end
