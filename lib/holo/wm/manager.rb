module Holo
  class WM
    class Manager
      attr_reader :display, :clients, :layout

      def initialize(display)
        @display  = display
        @clients  = []
        @layout   = Layout.new(display)
      end

      def to_s
        clients.join $/
      end

      def map(window)
        return if window.override_redirect?
        return if client_for window
        manage Client.new(window)
      end

      def unmap(window)
      end

      def remove(window)
        unmanage client_for window
      end


      private

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
