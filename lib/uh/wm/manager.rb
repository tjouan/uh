module Uh
  class WM
    class Manager
      DEFAULT_GEO = Geo.new(0, 0, 320, 240).freeze

      extend Forwardable
      def_delegator :@logger, :info, :log

      def initialize(logger)
        @logger     = logger
        @clients    = []
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
          log "#{self.class.name}#configure #{client} already managed"
          client.configure
        else
          geo = @on_configure ? @on_configure.call(window) : DEFAULT_GEO
          log "#{self.class.name}#configure window: #{window}, not managed"
          log "#{window.class.name}#configure #{geo}"
          window.configure_event geo
        end
      end

      def map(window)
        if window.override_redirect?
          log "#{self.class.name}#map #{window}.override_redirect, skipping"
          return
        end

        if client = client_for(window)
          log "#{self.class.name}#map #{client}, already managed"
          nil
        else
          Client.new(window).tap { |o| manage o }
        end
      end

      def unmap(window)
      end

      def destroy(window)
        remove_client_for window
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

      def remove_client_for(window)
        return unless client = client_for(window)
        unmanage client
      end

      def manage(client)
        log "#{self.class.name}#manage #{client}"
        @clients << client
        @on_manage.call client if @on_manage
      end

      def unmanage(client)
        log "#{self.class.name}#unmanage #{client}"
        @clients.reject! { |e| e == client }
        @on_unmanage.call client if @on_unmanage
      end
    end
  end
end
