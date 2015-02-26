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
        window.configure geo
        self
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
        if window.icccm_wm_protocols.include? :WM_DELETE_WINDOW
          window.icccm_wm_delete
        else
          window.kill!
        end
        self
      end

      def kill!
        window.kill
        self
      end
    end
  end
end
