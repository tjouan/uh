module Holo
  class WM
    class Layout
      attr_reader :manager, :current_client

      def initialize(manager)
        @manager        = manager
        @current_client = nil
      end

      def arrange_for(client)
        manager.hide visible_clients
        client.geo = manager.screens.first.geo.dup
        client.moveresize
        @current_client = client
        manager.show visible_clients
      end

      def visible_clients
        [@current_client].compact
      end
    end
  end
end
