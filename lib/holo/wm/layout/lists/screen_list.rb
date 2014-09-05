module Holo
  class WM
    class Layout
      module Lists
        class ScreenList < BaseList
          def initialize(*screens)
            @entries        = screens.map { |e| yield e }
            @current_index  = 0
          end
        end
      end
    end
  end
end
