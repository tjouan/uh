module Holo
  class WM
    class Client
      attr_reader :window, :geo

      def initialize(window)
        @window = window
        @geo    = Geo.new
      end
    end
  end
end
