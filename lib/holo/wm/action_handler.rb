module Holo
  class WM
    class ActionHandler
      attr_reader :wm

      def initialize(wm)
        @wm = wm
      end

      def call(action)
        instance_exec &action
      end

      def quit
        puts '> ACTION: QUIT'
        wm.request_quit!
      end

      def execute(command)
        puts '> ACTION: SPAWN `%s`' % command
        pid = spawn command, pgroup: true
        Process.detach pid
      rescue Errno::ENOENT
        ;
      end

      def focus_next_client
        wm.manager.focus_next_client
      end

      def log_clients
        puts '> CLIENTS:'
        wm.manager.to_s.lines.each { |e| puts "  #{e}" }
      end

      def log_line
        puts '-' * 80
      end
    end
  end
end
