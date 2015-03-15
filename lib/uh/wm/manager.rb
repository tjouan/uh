module Uh
  class WM
    class Manager
      DEFAULT_GEO = Geo.new(0, 0, 320, 240).freeze

      attr_reader :clients

      def initialize
        @clients = []
      end

      def to_s
        @clients.join $/
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

      def on_change(&block)
        @on_change = block
      end

      def configure(window)
        if client = client_for(window)
          client.configure
        else
          geo = @on_configure ? @on_configure.call(window) : DEFAULT_GEO
          window.configure_event geo
        end
      end

      def map(window)
        return if window.override_redirect? || client_for(window)
        Client.new(window).tap { |o| manage o }
      end

      def unmap(window)
        return unless client = client_for(window)
        if client.unmap_count > 0
          client.unmap_count -= 1
        else
          unmanage client
        end
      end

      def destroy(window)
        return unless client = client_for(window)
        unmanage client
      end

      def update_properties(window)
        return unless client = client_for(window)
        client.update_window_properties
        @on_change.call client if @on_change
      end


      private

      def client_for(window)
        @clients.find { |e| e.window == window }
      end

      def manage(client)
        @clients << client
        @on_manage.call client if @on_manage
      end

      def unmanage(client)
        @clients.reject! { |e| e == client }
        @on_unmanage.call client if @on_unmanage
      end
    end
  end
end
