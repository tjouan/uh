module Holo
  class Pixmap
    def copy(window)
      _copy window.id, width, height
    end
  end
end
