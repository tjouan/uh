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
          puts '  window.override_redirect, skipping'
          return
        end

        if client = client_for(window)
          puts '  client %s already managed' % client
        else
          manage Client.new(window)
        end
      end

      def unmap(window)
        if client = client_for(window)
          puts '  client %s is managed' % client
        else
          puts '  window not managed #%d' % window.id
        end
      end

      def configure(window)
        if client = client_for(window)
          puts '  client %s already managed' % client
          client.configure
        else
          geo = layout.suggest_geo_for_client
          puts '  window %d not managed, suggesting %s' % [window.id, geo]
          puts '  configure event %s' % geo
          window.configure_event geo
        end
      end

      def destroy(window)
        return unless client = client_for(window)
        unmanage client
      end


      private

      def client_for(window)
        clients.find { |e| e.window == window }
      end

      def manage(client)
        puts '  %s.manage %s' % [self.class, client]
        clients << client
        layout  << client
      end

      def unmanage(client)
        puts '  %s.unmanage %s' % [self.class, client]
        clients.reject! { |e| e == client}
        layout.remove client
      end
    end
  end
end
