module Holo
  class WM
    require 'holo/wm/action_handler'
    require 'holo/wm/client'
    require 'holo/wm/layout'
    require 'holo/wm/manager'

    INPUT_MASK  = SUBSTRUCTURE_REDIRECT_MASK
    ROOT_MASK   = PROPERTY_CHANGE_MASK |
                  SUBSTRUCTURE_REDIRECT_MASK |
                  SUBSTRUCTURE_NOTIFY_MASK |
                  STRUCTURE_NOTIFY_MASK

    attr_reader :modifier, :keys, :action_handler, :manager, :display

    def initialize(&block)
      @quit_requested = false
      @modifier       = MODIFIERS[:mod1]
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

    def key(key, mod = nil, &block)
      mod = mod ? modifier | MODIFIERS[mod] : modifier
      @keys[[key.to_s.gsub(/\AXK_/, ''), mod]] = block
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


    private

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
      keys.each { |k, v| display.grab_key *k }
    end

    def setup_manager
      @manager = Manager.new(display)
    end

    def read_events
      display.root_change_attributes ROOT_MASK

      while !quit_requested? do
        event = display.next_event
        next unless respond_to? event_handler_method(event), true
        puts '> Event %s' % event.type.inspect
        send event_handler_method(event), event
      end
    end

    def event_handler_method(event)
      ('handle_%s' % event.type).to_sym
    end

    def handle_configure_request(event)
      display.window_configure event.window
    end

    def handle_destroy_notify(event)
      manager.remove event.window
    end

    def handle_expose(event)
    end

    def handle_key_press(event)
      action_handler.call keys[[event.key, event.mod]]
    end

    def handle_map_request(event)
      manager.map event.window
    end

    def handle_property_notify(event)
    end

    def handle_unmap_notify(event)
      manager.unmap event.window
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
