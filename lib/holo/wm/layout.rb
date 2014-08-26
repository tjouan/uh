module Holo
  class WM
    class Layout
      require 'holo/wm/layout/tag'

      attr_reader :manager, :tags, :current_tag

      def initialize(manager)
        @manager        = manager
        @tags           = [Tag.new(1)]
        @current_tag    = tags.first
      end

      def current_client
        current_tag.current_client
      end

      def visible_clients
        current_tag.visible_clients
      end

      def <<(client)
        visible_clients.each(&:hide)
        current_tag << client
        arrange visible_clients
        visible_clients.each(&:show)
        focus_current_client
      end

      def remove(client)
        tags.each do |t|
          next unless t.include? client
          t.remove client
          if t == current_tag
            visible_clients.each(&:show)
          end
        end
        focus_current_client
      end

      def arrange(clients)
        clients.each do |c|
          c.geo = manager.screens.first.geo.dup
          c.moveresize
        end
      end

      def focus_current_client
        current_client.focus if current_client
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

      def handle_sel_next
        visible_clients.each(&:hide)
        current_tag.sel_next
        visible_clients.each(&:show)
        focus_current_client
      end

      def handle_sel_prev
        visible_clients.each(&:hide)
        current_tag.sel_prev
        visible_clients.each(&:show)
        focus_current_client
      end


      private

      def find_or_create_tag(id)
        tags << tag = Tag.new(id) unless tag = tags.find { |e| e.id == id }
        tag
      end
    end
  end
end
