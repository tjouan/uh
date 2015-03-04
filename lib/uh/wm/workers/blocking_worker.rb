module Uh
  class WM
    module Workers
      class BlockingWorker < BaseWorker
        def each_event
          @display.each_event { |e| yield e }
        end
      end
    end
  end
end
