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
        if window.override_redirect?
          puts '  override_redirect, skipping'
          return
        end

        if client = client_for(window)
          puts '  client `%s\' already managed, skipping' % client
        else
          manage Client.new(window)
        end
      end

      def unmap(window)
        if client = client_for(window)
          puts '  client `%s\' is managed' % client
        else
          puts '  window not managed #%d' % window.id
        end
      end

      def remove(window)
        unmanage client_for window
      end


      private

      def client_for(window)
        clients.find { |e| e.window == window }
      end

      def manage(client)
        puts '  managing `%s\'' % client
        clients << client
        layout  << client
      end

      def unmanage(client)
        puts '  unmanaging `%s\'' % client
        clients.reject! { |e| e == client}
        layout.remove client
      end
    end
  end
end
