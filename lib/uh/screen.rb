module Uh
  class Screen
    def geo
      @geo ||= Geo.new x, y, width, height
    end
  end
end
