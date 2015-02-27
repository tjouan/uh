module Holo
  class WM
    module Workers
      class BaseWorker
        def initialize(display, logger, **options)
          @display  = display
          @logger   = logger
          configure **options
        end

        def configure(**options)
        end

        def setup
          self
        end
      end
    end
  end
end
