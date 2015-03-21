module Uh
  class WM
    class ActionHandler
      extend Forwardable
      def_delegators :@wm, :log, :log_error

      attr_reader :layout

      def initialize(wm, manager, layout)
        @wm, @manager, @layout = wm, manager, layout
      end

      def call(action)
        instance_exec &action
      rescue LocalJumpError => e
        log_error "Action: #{e}"
      end

      def quit
        log 'Exiting...'
        @wm.request_quit!
      end

      def execute(command)
        log "Spawn `#{command}`"
        pid = fork do
          fork do
            Process.setsid
            begin
              exec command
            rescue Errno::ENOENT => e
              log_error "Spawn: #{e}"
            end
          end
        end
        Process.waitpid pid
      end

      def log_layout
        log "Layout:\n#{@layout.to_s.lines.map { |e| "  #{e}" }.join.chomp}"
      end

      def log_clients
        log "Clients:\n#{@manager.to_s.lines.map { |e| "  #{e}" }.join.chomp}"
      end

      def log_separator
        log '- ' * 24
      end

      def method_missing(m, *args, &block)
        if respond_to? m
          meth = layout_method m
          log "#{@layout.class.name}##{meth} #{args.inspect}"
          begin
            @layout.send(meth, *args)
          rescue NoMethodError
            log_error "Layout does not implement `#{meth}'"
          end
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
