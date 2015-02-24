module Holo
  class WM
    class Client
      attr_reader   :window
      attr_accessor :geo

      def initialize(window)
        @window = window
      end

      def to_s
        '<%s> (%s) window: %s, geo: %s' % [name, wclass, window, geo]
      end

      def name
        @name ||= window.name
      end

      def wclass
        @wclass ||= window.wclass
      end

      def configure
        puts '  %s#configure %s' % [self.class, self]
        window.configure geo
        self
      end

      def moveresize
        puts '  %s#moveresize %s' % [self.class, self]
        window.moveresize geo
        self
      end

      def show
        puts '  %s#show %s' % [self.class, self]
        window.map
        self
      end

      def hide
        puts '  %s#hide %s' % [self.class, self]
        window.unmap
        self
      end

      def focus
        puts '  %s#{raise,focus} %s' % [self.class, self]
        window.raise
        window.focus
        self
      end

      def kill
        puts '  %s#kill %s' % [self.class, self]
        window.kill
        self
      end
    end
  end
end
