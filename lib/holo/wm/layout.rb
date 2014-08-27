module Holo
  class WM
    class Layout
      require 'holo/wm/layout/col'
      require 'holo/wm/layout/tag'

      attr_reader :geo, :tags, :current_tag

      def initialize(geo)
        @geo          = geo
        @tags         = [Tag.new(1, geo)]
        @current_tag  = tags.first
      end

      def to_s
        tags.sort_by(&:id).inject('') do |m, tag|
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

      def current_client
        current_tag.current_client
      end

      def visible_clients
        current_tag.visible_clients
      end

      def <<(client)
        current_tag << client
        focus_current_client
      end

      def remove(client)
        tags.each { |e| e.remove client }
        focus_current_client
      end

      def focus_current_client
        current_client and current_client.focus
      end

      def handle_tag_sel(tag_id)
        return unless @current_tag.id != tag_id
        visible_clients.each(&:hide)
        @current_tag = find_or_create_tag tag_id
        visible_clients.each(&:show)
        focus_current_client
      end

      def handle_tag_set(tag_id)
        return unless @current_tag.id != tag_id
        visible_clients.each(&:hide)
        client = current_tag.current_client
        current_tag.remove client
        find_or_create_tag(tag_id) << client
        visible_clients.each(&:show)
        focus_current_client
      end

      def handle_sel_prev
        current_tag.sel_prev
      end

      def handle_sel_next
        current_tag.sel_next
      end

      def handle_col_sel_prev
      end

      def handle_col_sel_next
      end

      def handle_col_set_prev
      end

      def handle_col_set_next
        current_tag.col_set_next
      end


      private

      def find_or_create_tag(id)
        tags << tag = Tag.new(id, geo) unless tag = tags.find { |e| e.id == id }
        tag
      end
    end
  end
end
