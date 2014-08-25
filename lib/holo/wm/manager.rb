module Holo
  class WM
    class Manager
      attr_reader :clients, :screens, :layout

      def initialize(clients, screens)
        @clients  = clients
        @screens  = screens
        @layout   = Layout.new(self)
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
        layout.arrange_for client
        layout.current_client.focus
      end

      def unmanage(client)
        clients.reject! { |e| e == client}
      end

      def show(cs)
        cs.each(&:show)
      end

      def hide(cs)
        cs.each(&:hide)
      end
    end
  end
end
