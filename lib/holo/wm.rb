module Holo
  class WM
    attr :keys, :client_rules

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
      while e = display.next_event do
        p e
      end
    end

    def quit
      display.close
    end

    def debug
      binding.pry
    end
  end
end

=begin
  class WM
    attr :keys, :client_rules

    def initialize(&block)
      @keys         = {}
      @client_rules = {}

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

    def client(name, &block)
      @client_rules[name] = block
    end

    def manage
      while true do; end
    end
  end
=end
