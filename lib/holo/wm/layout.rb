module Holo
  class WM
    class Layout
      class Tag
        attr_reader :clients, :current_client

        def initialize(id, clients = [])
          @id             = id
          @clients        = clients
          @current_client = nil
        end

        def visible_clients
          [current_client].compact
        end

        def include?(client)
          clients.include? client
        end

        def <<(client)
          clients << client
          @current_client = client
        end

        def remove(client)
          clients.reject! { |e| e == client}
          @current_client = clients.last
        end
      end


      attr_reader :manager, :tags, :current_tag

      def initialize(manager)
        @manager        = manager
        @tags           = [Tag.new(1)]
        @current_tag    = tags.first
      end

      def current_client
        current_tag.current_client
      end

      def arrange_for(client)
        manager.hide current_tag.visible_clients
        current_tag << client
        update_geo_for current_tag.visible_clients
        manager.show current_tag.visible_clients
      end

      def remove(client)
        tags.each do |t|
          next unless t.include? client
          t.remove client
          update_geo_for t.visible_clients
          if t == current_tag
            manager.moveresize current_tag.visible_clients
            manager.show current_tag.visible_clients
          end
        end
      end

      def update_geo_for(cs)
        cs.each do |c|
          c.geo = manager.screens.first.geo.dup
          c.moveresize
        end
      end

      def sel_next
        #manager.hide visible_clients
      end

      def sel_prev
      end
    end
  end
end
