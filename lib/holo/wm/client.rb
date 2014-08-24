module Holo
  class WM
    class Client
      attr_reader   :window
      attr_accessor :geo

      def initialize(window)
        @window = window
      end

      def to_s
        '<%s> (%s) #TAG.COL %s' % [
          name,
          wclass,
          geo
        ]
      end

      def name
        @name ||= window.name
      end

      def wclass
        @wclass ||= window.wclass
      end

      def moveresize
        window.moveresize geo
      end

      def map
        window.map
      end

      def focus
        window.raise
        window.focus
      end
    end
  end
end
