require 'uh/geo_accessors'

module Uh
  class WM
    class Client
      include GeoAccessors

      attr_reader   :window
      attr_accessor :geo, :unmap_count

      def initialize(window)
        @window       = window
        @hide         = true
        @unmap_count  = 0
      end

      def to_s
        '<%s> (%s) %s win: %s unmaps: %d' %
          [name, wclass, @geo, @window, @unmap_count]
      end

      def name
        @name ||= @window.name
      end

      def wclass
        @wclass ||= @window.wclass
      end

      def hidden?
        @hide
      end

      def update_window_properties
        @name   = @window.name
        @wclass = @window.wclass
      end

      def configure
        @window.configure @geo
        self
      end

      def moveresize
        @window.moveresize @geo
        self
      end

      def show
        @window.map
        @hide = false
        self
      end

      def hide
        @window.unmap
        @hide = true
        @unmap_count += 1
        self
      end

      def focus
        @window.raise
        @window.focus
        self
      end

      def kill
        if @window.icccm_wm_protocols.include? :WM_DELETE_WINDOW
          @window.icccm_wm_delete
        else
          @window.kill
        end
        self
      end

      def kill!
        @window.kill
        self
      end
    end
  end
end
