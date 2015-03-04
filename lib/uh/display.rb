module Uh
  class Display
    def create_subwindow(geo)
      root.create_sub geo
    end

    def font
      @font ||= query_font
    end

    def pending?
      pending > 0
    end
  end
end
