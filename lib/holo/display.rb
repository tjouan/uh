module Holo
  class Display
    def window_configure(window_id)
      Window.configure(self, window_id)
    end
  end
end
