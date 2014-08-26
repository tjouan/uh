module Holo
  class WM
    class Manager
      attr_reader :clients, :screens, :layout

      def initialize(clients, screens)
        @clients  = clients
        @screens  = screens
        @layout   = Layout.new(screens.first.geo)
      end

      def to_s
        clients.join $/
      end

      def map(window)
        # FIXME: get window attributes, check if override_redirect is true and return
        return if client_for window
        manage Client.new(window)
      end

      def unmap(window)
      end

      def remove(window)
        unmanage client_for window
      end

      def client_for(window)
        clients.find { |e| e.window == window }
      end

      def manage(client)
        clients << client
        layout  << client
      end

      def unmanage(client)
        clients.reject! { |e| e == client}
        layout.remove client
      end
    end
  end
end
