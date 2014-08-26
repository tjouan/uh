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
        focus_current_client
      end

      def unmanage(client)
        clients.reject! { |e| e == client}
        layout.remove client
        focus_current_client
      end

      def focus_current_client
        layout.current_client.focus if layout.current_client
      end

      def focus_next_client
        layout.sel_next
        focus_current_client
      end

      def focus_prev_client
        layout.sel_prev
        focus_current_client
      end
    end
  end
end
