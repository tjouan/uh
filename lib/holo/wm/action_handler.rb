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

      def focus_prev_client
        wm.manager.focus_prev_client
      end

      def log_clients
        puts '> CLIENTS:'
        wm.manager.to_s.lines.each { |e| puts "  #{e}" }
      end

      def log_line
        puts '-' * 80
      end

      def method_missing(m, *args, &block)
        return wm.manager.layout.send(layout_method(m), *args) if respond_to? m
        super
      end

      def respond_to_missing?(m, *)
        m.to_s =~ /\Alayout_/ || super
      end


      private

      def layout_method(m)
        m.to_s.gsub(/\Alayout_/, 'handle_').to_sym
      end
    end
  end
end
