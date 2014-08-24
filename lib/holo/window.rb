module Holo
  class Window
    def moveresize(geo)
      _moveresize geo.x, geo.y, geo.width, geo.height
    end
  end
end
