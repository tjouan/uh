module Holo
  class WM
    class Manager
      attr_reader :clients, :screens

      def initialize(clients, screens)
        @clients  = clients
        @screens  = screens

        p screens
      end

      def to_s
        clients.join $/
      end

      def handle(window)
        # FIXME: get window attributes, check if override_redirect is true and return
        manage Client.new(window) unless client? window
      end

      def client?(window)
        clients.any? { |e| e.window == window }
      end

      def manage(client)
        clients << client
        Layout.new(visible_clients, current_screen).arrange
        visible_clients.each { |e| e.moveresize }
        client.map
      end

      def visible_clients
        clients
      end

      def current_screen
        screens.first
      end
    end
  end
end
