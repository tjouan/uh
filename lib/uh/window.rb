module Uh
  class Window
    def to_s
      id.to_s
    end

    def == other
      id == other.id
    end

    def cursor cursor_name
      self.cursor = Uh::CURSORS[cursor_name]
    end
  end
end
