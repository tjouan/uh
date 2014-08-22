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

    def quit_requested?
      @quit_requested
    end

    def key(key, &block)
      @keys[key] = block
    end

    def display
      @display ||= Holo::Display.new(ENV['DISPLAY'])
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
        e = display.next_event
        p e
        case e
        when Events::KeyPress
          @keys[e.key].call
        end
      end
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

    def spawn(command)
      puts "SPAWN: #{command.inspect}"
    end
  end
end
