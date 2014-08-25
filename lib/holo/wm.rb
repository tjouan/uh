module Holo
  class WM
    require 'holo/wm/action_handler'
    require 'holo/wm/client'
    require 'holo/wm/layout'
    require 'holo/wm/manager'

    INPUT_MASK  = SubstructureRedirectMask
    ROOT_MASK   = (PropertyChangeMask | SubstructureRedirectMask |
                  SubstructureNotifyMask | StructureNotifyMask)

    attr_accessor :keys, :action_handler, :manager, :display

    def initialize(&block)
      @quit_requested = false
      @keys           = {}
      @action_handler = ActionHandler.new(self)
      @display        = Display.new

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

    def quit_requested?
      @quit_requested
    end

    def request_quit!
      @quit_requested = true
    end

    def run
      connect
      grab_keys
      setup_manager
      read_events
      disconnect
    end

    def connect
      display.open
      Display.on_error proc { fail OtherWMRunningError }
      display.listen_events INPUT_MASK
      display.sync false
      Display.on_error proc { |*args| handle_error(*args) }
      display.sync false
    end

    def disconnect
      display.close
    end

    def grab_keys
      keys.each { |k, v| display.grab_key k }
    end

    def setup_manager
      @manager = Manager.new([], display.screens)
    end

    def read_events
      display.root_change_attributes ROOT_MASK

      while !quit_requested? do
        event = display.next_event
        m = ('handle_%s' % event.type).to_sym
        handled = respond_to? m
        log_event event, handled ? '' : '?'
        send m.to_sym, event if handled
      end
    end

    def log_event(event, suffix = '')
      puts '> EVENT%s: %s' % [suffix, event.inspect]
    end

    def handle_configure_request(event)
      display.window_configure event.window
    end

    def handle_destroy_notify(event)
      manager.remove event.window
    end

    def handle_map_request(event)
      manager.handle event.window
    end

    def handle_key_press(event)
      action_handler.call keys[event.key]
    end

    def handle_unmap_notify(event)
      #manager.remove event.window
    end

    def handle_event(event)
    end

    def handle_error(req, resource_id, msg)
      $stderr.puts '> ERROR: XErrorEvent %s(0x%x): %s' % [
        req,
        resource_id,
        msg
      ]
    end
  end
end
