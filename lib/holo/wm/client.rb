module Holo
  class WM
    class Client
      attr_reader   :window
      attr_accessor :geo

      def initialize(window)
        @window = window
      end

      def to_s
        '<%s> (%s) %s' % [name, wclass, geo]
      end

      def name
        @name ||= window.name
      end

      def wclass
        @wclass ||= window.wclass
      end

      def moveresize
        window.moveresize geo
        self
      end

      def show
        window.map
        self
      end

      def hide
        window.unmap
        self
      end

      def focus
        window.raise
        window.focus
        self
      end

      def kill
        window.kill
        self
      end
    end
  end
end
