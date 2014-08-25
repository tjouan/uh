module Holo
  class Display
    def window_configure(window)
      Window.configure(self, window.id)
    end
  end
end
