module Holo
  class WM
    class Layout
      class ScreenList
        extend Forwardable
        def_delegators  :@screens, :each, :inject
        def_delegator   :current, :==, :current?

        def initialize(screens)
          @screens        = screens.map { |e| yield e }
          @current_index  = 0
        end

        def current
          @screens[@current_index]
        end

        def remove(client)
          @screens.each { |e| e.remove client }
        end

        def sel_next
          @current_index = @current_index.succ % @screens.size
        end
      end
    end
  end
end
