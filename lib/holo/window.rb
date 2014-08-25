module Holo
  class Window
    def ==(other)
      id == other.id
    end

    def moveresize(geo)
      _moveresize geo.x, geo.y, geo.width, geo.height
    end
  end
end
