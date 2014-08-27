module Holo
  class WM
    class ActionHandler
      attr_reader :wm

      def initialize(wm)
        @wm = wm
      end

      def call(action)
        instance_exec &action
        log_line
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

      def log_layout
        puts '> LAYOUT:'
        wm.manager.layout.to_s.lines.each { |e| puts "  #{e}" }
      end

      def log_clients
        puts '> CLIENTS:'
        wm.manager.to_s.lines.each { |e| puts "  #{e}" }
      end

      def log_line
        puts '-' * 80
      end

      def method_missing(m, *args, &block)
        if respond_to? m
          wm.manager.layout.send(layout_method(m), *args)
          puts '> LAYOUT -> %s' % layout_method(m)
        else
          super
        end
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
