module Uh
  class Display
    def to_s
      ENV['DISPLAY']
    end

    def check!
      fail DisplayError, 'display not opened' unless opened?
    end

    def color_by_name color_name
      Color.new self, color_name
    end

    def create_image width, height, image
      Image.new self, width, height, image
    end

    def create_pixmap width, height
      Pixmap.new self, width, height
    end

    def create_window geo
      root.create geo
    end

    def create_subwindow geo
      root.create_sub geo
    end

    def font
      @font ||= query_font
    end

    def pending?
      pending > 0
    end

    def query_font
      Font.new self
    end
  end
end
