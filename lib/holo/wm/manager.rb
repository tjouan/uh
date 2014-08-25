module Holo
  class WM
    class Manager
      attr_reader :clients, :screens

      def initialize(clients, screens)
        @clients  = clients
        @screens  = screens
      end

      def to_s
        clients.join $/
      end

      def handle(window)
        # FIXME: get window attributes, check if override_redirect is true and return
        return if client_for window
        manage Client.new(window)
      end

      def remove(window)
        unmanage client_for window
      end

      def client_for(window)
        clients.find { |e| e.window == window }
      end

      def manage(client)
        clients << client
        Layout.new(visible_clients, current_screen).arrange
        visible_clients.each { |e| e.moveresize }
        client.map
        client.focus
      end

      def unmanage(client)
        clients.reject! { |e| e == client}
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
