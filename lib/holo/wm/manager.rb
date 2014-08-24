module Holo
  class WM
    class Manager
      attr_reader :clients, :layout

      def initialize
        @clients  = []
        @layout   = Layout.new(clients)
      end

      def to_s
        clients.join $/
      end

      def handle(window)
        manage(window) unless client? window
      end

      def client?(window)
        clients.any? {  |e| e.window == window }
      end

      def manage(window)
        client = Client.new(window)
        clients << client
        layout.arrange
        window.moveresize client.geo
        window.map
      end
    end
  end
end
