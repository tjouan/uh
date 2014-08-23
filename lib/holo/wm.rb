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
      read_events
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

    def read_events
      display.sync false
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
        when Events::MapRequest
          handle_map_request event
        end
      end
    end

    def handle_configure_request(event)
      display.window_configure event.window_id
    end

    def handle_map_request(event)
      # FIXME: implement real window instance, would simplify things
      # FIXME: get window attributes, check if override_redirect is true and return
      manager.manage(event.window) unless manager.client? event.window
    end

    class Manager
      def initialize
        @clients = []
      end

      def client?(window)
        @clients.include? window
      end

      def manage(window)
        @clients << window
        window.moveresize 0, 0, 484, 100
        window.map
      end
    end
    def manager
      @manager ||= Manager.new
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
