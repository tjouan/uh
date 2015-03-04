module Uh
  class WM
    module Workers
      class MultiplexingWorker < BaseWorker
        DEFAULT_TIMEOUT = 4

        def configure(timeout: DEFAULT_TIMEOUT)
          @timeout = timeout
        end

        def setup
          @display_io = IO.new(@display.fileno)
          @display.flush
          self
        end

        def each_event
          loop do
            @logger.debug "select [#{@display_io.fileno}], _, _, #{@timeout}"
            rs, _ = IO.select [@display_io], [], [], @timeout
            @logger.debug " => #{rs.inspect}"
            next if rs.nil? || rs.empty?
            yield @display.next_event while @display.pending?
          end
        end
      end
    end
  end
end
