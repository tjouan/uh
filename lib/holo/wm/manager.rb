module Holo
  class WM
    class Manager
      DEFAULT_GEO = Geo.new(0, 0, 320, 240).freeze

      attr_reader :clients

      def initialize
        @clients = []
      end

      def to_s
        clients.join $/
      end

      def on_configure(&block)
        @on_configure = block
      end

      def on_manage(&block)
        @on_manage = block
      end

      def on_unmanage(&block)
        @on_unmanage = block
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
        remove_client_for window
      end

      def configure(window)
        if client = client_for(window)
          puts '  client %s already managed' % client
          client.configure
        else
          geo = @on_configure ? @on_configure.call(window) : DEFAULT_GEO
          puts '  window %d not managed, suggesting %s' % [window.id, geo]
          puts '  configure event %s' % geo
          window.configure_event geo
        end
      end

      def destroy(window)
        remove_client_for window
      end


      private

      def client_for(window)
        clients.find { |e| e.window == window }
      end

      def remove_client_for(window)
        return unless client = client_for(window)
        unmanage client
      end

      def manage(client)
        puts '  %s#manage %s' % [self.class, client]
        clients << client
        @on_manage.call client if @on_manage
      end

      def unmanage(client)
        puts '  %s#unmanage %s' % [self.class, client]
        clients.reject! { |e| e == client}
        @on_unmanage.call client if @on_unmanage
      end
    end
  end
end
