module Holo
  class WM
    class Client
      attr_reader   :window
      attr_accessor :geo

      def initialize(window)
        @window = window
      end

      def moveresize
        window.moveresize geo
      end

      def map
        window.map
      end
    end
  end
end
