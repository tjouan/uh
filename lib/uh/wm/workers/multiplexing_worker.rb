module Uh
  class WM
    module Workers
      class MultiplexingWorker < BaseWorker
        DEFAULT_TIMEOUT = 4

        def configure(timeout: DEFAULT_TIMEOUT, on_timeout: nil)
          @timeout    = timeout
          @on_timeout = on_timeout
        end

        def setup
          @display_io = IO.new(@display.fileno)
          self
        end

        def each_event
          loop do
            @display.flush
            @logger.debug "select [#{@display_io.fileno}], _, _, #{@timeout}"
            rs, _ = IO.select [@display_io], [], [], @timeout
            @logger.debug " => #{rs.inspect}"
            if rs.nil? || rs.empty?
              @on_timeout.call if @on_timeout
            else
              yield @display.next_event while @display.pending?
            end
          end
        end
      end
    end
  end
end
