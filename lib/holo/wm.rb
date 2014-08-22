module Holo
  class WM
    attr_accessor :keys

    def initialize(&block)
      @quit_requested = false
      @keys           = {}

      return unless block_given?

      if block.arity == 1
        yield self
      else
        instance_eval &block
      end
    end

    def run
      connect
      manage
      disconnect
    end

    def connect
      display.open
      # FIXME: we must specify type
      display.listen_events
    end

    def disconnect
      display.close
    end

    def manage
      # FIXME: specify discard: false
      display.sync
      # FIXME: specify attributes
      display.change_window_attributes
      grab_keys

      while !quit_requested? do
        event = display.next_event
        p event
        case event
        when Events::ConfigureRequest
          handle_configure_request event
        when Events::KeyPress
          @keys[event.key].call
        end
      end
    end

    def handle_configure_request(event)
      display.window_configure event.window_id
    end

    def quit_requested?
      @quit_requested
    end

    def key(key, &block)
      @keys[key] = block
    end

    def display
      @display ||= Holo::Display.new(ENV['DISPLAY'])
    end

    def grab_keys
      keys.each { |k, v| display.grab_key k }
    end

    def debug
      binding.pry
    end

    def quit
      puts "QUIT"
      @quit_requested = true
    end

    def execute(command)
      puts "SPAWN: #{command.inspect}"
      pid = spawn command, pgroup: true
      Process.detach pid
    rescue Errno::ENOENT
      ;
    end
  end
end
