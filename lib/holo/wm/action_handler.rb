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
        puts 'ACTION: QUIT'
        wm.request_quit!
      end

      def execute(command)
        puts 'ACTION: SPAWN `%s`' % command
        pid = spawn command, pgroup: true
        Process.detach pid
      rescue Errno::ENOENT
        ;
      end
    end
  end
end
