module Holo
  class WM
    class Manager
      def initialize
        @clients = []
      end

      def client?(window)
        @clients.include? window
      end

      def manage(window)
        @clients << window
        window.moveresize 0, 0, 484, 300
        window.map
      end
    end
  end
end
