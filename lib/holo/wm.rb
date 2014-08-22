module Holo
  class WM
    attr :keys

    def initialize(&block)
      @keys = {}

      return unless block_given?

      if block.arity == 1
        yield self
      else
        instance_eval &block
      end
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

    def manage
      # FIXME: specify discard: false
      display.sync
      # FIXME: specify attributes
      display.change_window_attributes
      grab_keys
      while e = display.next_event do
        p e
      end
    end

    def grab_keys
      keys.each { |k, v| display.grab_key k }
    end

    def quit
      display.close
    end

    def debug
      binding.pry
    end
  end
end
