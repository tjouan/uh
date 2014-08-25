module Holo
  class WM
    class Layout
      class Tag
        attr_reader :id, :clients, :current_client

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

      def visible_clients
        current_tag.visible_clients
      end

      def <<(client)
        visible_clients.each(&:hide)
        current_tag << client
        arrange visible_clients
        visible_clients.each(&:show)
      end

      def remove(client)
        tags.each do |t|
          next unless t.include? client
          t.remove client
          if t == current_tag
            visible_clients.each(&:show)
          end
        end
      end

      def arrange(clients)
        clients.each do |c|
          c.geo = manager.screens.first.geo.dup
          c.moveresize
        end
      end

      def sel_next
      end

      def sel_prev
      end
    end
  end
end
