module Holo
  class Window
    def to_s
      id.to_s
    end

    def ==(other)
      id == other.id
    end

    def configure(geo)
      _configure geo.x, geo.y, geo.width, geo.height
      self
    end

    def configure_event(geo)
      _configure_event geo.x, geo.y, geo.width, geo.height
      self
    end

    def create_sub(geo)
      _create_sub geo.x, geo.y, geo.width, geo.height
    end

    def moveresize(geo)
      _moveresize geo.x, geo.y, geo.width, geo.height
      self
    end

    def show
      map
      self
    end
  end
end
