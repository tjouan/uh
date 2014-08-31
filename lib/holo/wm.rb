module Holo
  class WM
    require 'holo/wm/action_handler'
    require 'holo/wm/client'
    require 'holo/wm/layout'
    require 'holo/wm/manager'

    include Events

    DEFAULT_MODIFIER  = :mod1
    INPUT_MASK        = SUBSTRUCTURE_REDIRECT_MASK
    ROOT_MASK         = PROPERTY_CHANGE_MASK |
                        SUBSTRUCTURE_REDIRECT_MASK |
                        SUBSTRUCTURE_NOTIFY_MASK |
                        STRUCTURE_NOTIFY_MASK

    attr_reader :keys, :action_handler, :manager, :display

    def initialize(&block)
      @modifier       = DEFAULT_MODIFIER
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

    def modifier(mod = nil)
      return @modifier unless mod
      @modifier = mod
    end

    def key(key, mod = nil, &block)
      mod_mask = KEY_MODIFIERS[modifier]
      mod_mask |= KEY_MODIFIERS[mod] if mod
      @keys[[key, mod_mask]] = block
    end

    def quit_requested?
      !!@quit_requested
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

    def modifier_mask(mod)
      KEY_MODIFIERS[mod]
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
      keys.each do |k, v|
        key, mod = *k
        key = key.to_s.gsub /\AXK_/, ''
        display.grab_key key, mod
      end
    end

    def setup_manager
      @manager = Manager.new(display)
    end

    def read_events
      display.root_change_attributes ROOT_MASK

      while !quit_requested? do
        event = display.next_event
        next unless respond_to? event_handler_method(event), true
        log_event event
        send event_handler_method(event), event
      end
    end

    def event_handler_method(event)
      ('handle_%s' % event.type).to_sym
    end

    def log_event(event)
      fmt         = '> Event %s'
      complement  = case event.type
      when :configure_request
        '%s, above: #%d, detail: #%d, value_mask: #%d' % [
          Geo.new(event.x, event.y, event.width, event.height),
          event.above_window_id,
          event.detail,
          event.value_mask
        ]
      else
        nil
      end

      puts fmt % [
        event.type,
        complement
      ].compact.join(' ')
    end

    def handle_configure_request(event)
      manager.configure event.window
    end

    def handle_destroy_notify(event)
      manager.destroy event.window
    end

    def handle_expose(event)
    end

    def handle_key_press(event)
      action_handler.call keys[["XK_#{event.key}".to_sym, event.modifier_mask]]
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
      $stderr.puts '> XERROR: %d, %s, %s' % [
        resource_id,
        req,
        msg
      ]
    end
  end
end
