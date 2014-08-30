module Holo
  class Display
    def create_subwindow(geo)
      root.create_sub geo
    end

    def font
      @font ||= query_font
    end
  end
end
