module Holo
  class WM
    require 'holo/wm/action_handler'
    require 'holo/wm/manager'

    attr_accessor :keys, :action_handler, :manager

    def initialize(&block)
      @quit_requested = false
      @keys           = {}
      @action_handler = ActionHandler.new(self)
      @manager        = Manager.new

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
      display.listen_events SubstructureRedirectMask
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
        puts '> EVENT: %s' % event.inspect
        m = ('handle_%s' % event.type).to_sym
        if respond_to? m
          send m.to_sym, event
        else
          ;
        end
      end
    end

    def handle_configure_request(event)
      display.window_configure event.window_id
    end

    def handle_map_request(event)
      # FIXME: get window attributes, check if override_redirect is true and return
      manager.manage(event.window) unless manager.client? event.window
    end

    def handle_key_press(event)
      action_handler.call keys[event.key]
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

    def request_quit!
      @quit_requested = true
    end
  end
end
