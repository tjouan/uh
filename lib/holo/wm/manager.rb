module Holo
  class WM
    class Manager
      DEFAULT_GEO = Geo.new(0, 0, 320, 240).freeze

      extend Forwardable
      def_delegator :@logger, :info, :log

      def initialize(logger)
        @logger   = logger
        @clients  = []
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

      def map(window)
        if window.override_redirect?
          log "#{self.class.name}#map window.override_redirect, skipping"
          return
        end

        if client = client_for(window)
          log "#{self.class.name}#map #{client}, already managed"
        else
          manage Client.new(window)
        end
      end

      def unmap(window)
        remove_client_for window
      end

      def configure(window)
        if client = client_for(window)
          log "#{self.class.name}#configure #{client} already managed"
          client.configure
        else
          geo = @on_configure ? @on_configure.call(window) : DEFAULT_GEO
          log "#{self.class.name}#configure #{window.inspect}, not managed"
          log '%s#configure %s#configure %s' % [
            self.class.name,
            window.class.name,
            geo
          ]
          window.configure_event geo
        end
      end

      def destroy(window)
        remove_client_for window, destroy: true
      end


      private

      def client_for(window)
        @clients.find { |e| e.window == window }
      end

      def remove_client_for(window, destroy: false)
        return unless client = client_for(window)
        unmanage client unless client.hidden? && !destroy
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
