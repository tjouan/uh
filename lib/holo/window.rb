module Holo
  class Window
    def ==(other)
      id == other.id
    end

    def create_sub(geo)
      _create_sub(geo.x, geo.y, geo.width, geo.height)
    end

    def moveresize(geo)
      _moveresize geo.x, geo.y, geo.width, geo.height
    end

    def show
      map
      self
    end
  end
end
