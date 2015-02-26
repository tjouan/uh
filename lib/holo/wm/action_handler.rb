module Holo
  class WM
    class ActionHandler
      def initialize(wm, manager, layout)
        @wm, @manager, @layout = wm, manager, layout
      end

      def call(action)
        @wm.log "#{self.class.name}#call #{action.inspect}"
        instance_exec &action
      end

      def quit
        @wm.log 'Exiting...'
        @wm.request_quit!
      end

      def execute(command)
        @wm.log "Spawn `#{command}`"
        pid = spawn command, pgroup: true
        Process.detach pid
      rescue Errno::ENOENT
      end

      def log_layout
        @wm.log "Layout:\n#{@layout.to_s.lines.map { |e| "  #{e}" }.join.chomp}"
      end

      def log_clients
        @wm.log "Clients:\n#{@manager.to_s.lines.map { |e| "  #{e}" }.join.chomp}"
      end

      def log_separator
        @wm.log '- ' * 24
      end

      def method_missing(m, *args, &block)
        if respond_to? m
          meth = layout_method m
          @wm.log "#{@layout.class.name}##{meth} #{args.inspect}"
          @layout.send(meth, *args)
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
