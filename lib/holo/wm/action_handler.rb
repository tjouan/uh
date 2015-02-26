module Holo
  class WM
    class ActionHandler
      attr_reader :wm

      def initialize(wm, layout)
        @wm, @layout = wm, layout
      end

      def call(action)
        log_line
        instance_exec &action
      end

      def quit
        puts '> Exiting...'
        wm.request_quit!
      end

      def execute(command)
        puts '> Spawn `%s`' % command
        pid = spawn command, pgroup: true
        Process.detach pid
      rescue Errno::ENOENT
      end

      def log_layout
        puts '> Layout:'
        @layout.to_s.lines.each { |e| puts "  #{e}" }
      end

      def log_clients
        puts '> Clients:'
        wm.manager.to_s.lines.each { |e| puts "  #{e}" }
      end

      def log_line
        puts '-' * 80
      end

      def method_missing(m, *args, &block)
        if respond_to? m
          puts '> Layout -> %s' % layout_method(m)
          @layout.send(layout_method(m), *args)
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
