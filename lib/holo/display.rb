module Holo
  class Display
    def window_configure(window)
      Window.configure(self, window.id)
    end

    def create_subwindow(geo)
      root.create_sub geo
    end

    def font
      @font ||= query_font
    end
  end
end
