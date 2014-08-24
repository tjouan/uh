module Holo
  class WM
    class Layout
      attr_reader :clients, :screen

      def initialize(clients, screen)
        @clients  = clients
        @screen   = screen
      end

      def arrange
        clients.each { |e| e.geo = screen.geo.dup }
      end
    end
  end
end
