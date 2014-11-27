module Holo
  class WM
    class CLI
      class << self
        def run!(arguments)
          new.run
        end
      end

      def run
        WM.default.run
      end
    end
  end
end
