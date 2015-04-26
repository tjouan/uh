module Uh
  class Window
    def to_s
      id.to_s
    end

    def ==(other)
      id == other.id
    end

    def show
      map
      self
    end
  end
end
