require 'forwardable'
require 'logger'
require 'holo/wm/action_handler'
require 'holo/wm/client'
require 'holo/wm/manager'
require 'holo/wm/workers/base_worker'
require 'holo/wm/workers/blocking_worker'
require 'holo/wm/workers/multiplexing_worker'

module Holo
  class WM
    include Events

    LOGGER_FORMAT_STR = "%s, %s.%03i %s\n".freeze
    LOGGER_FORMATER   = proc do |severity, datetime, progname, message|
      LOGGER_FORMAT_STR % [
        severity[0..0],
        datetime.strftime('%FT%T'),
        datetime.usec / 1000,
        message
      ]
    end
    LOGGER_LEVEL      = Logger::INFO
    LOGGER_DEBUG_ENV  = 'HOLO_DEBUG'.freeze

    WORKERS           = {
      blocking:     Workers::BlockingWorker,
      multiplexing: Workers::MultiplexingWorker
    }.freeze

    DEFAULT_MODIFIER  = :mod1
    INPUT_MASK        = SUBSTRUCTURE_REDIRECT_MASK
    ROOT_MASK         = PROPERTY_CHANGE_MASK |
                        SUBSTRUCTURE_REDIRECT_MASK |
                        SUBSTRUCTURE_NOTIFY_MASK |
                        STRUCTURE_NOTIFY_MASK

    extend Forwardable
    def_delegators :@manager, :on_configure, :on_manage, :on_unmanage
    def_delegator :@logger, :info, :log

    def initialize(layout, &block)
      @layout         = layout
      @display        = Display.new
      @logger         = Logger.new($stdout).tap do |o|
        o.level     = ENV.key?(LOGGER_DEBUG_ENV) ? Logger::DEBUG : LOGGER_LEVEL
        o.formatter = LOGGER_FORMATER
      end
      @manager        = Manager.new(@logger)
      @action_handler = ActionHandler.new(self, @manager, layout)
      @keys           = {}

      return unless block_given?
      if block.arity == 1 then yield self else instance_eval &block end
    end

    def modifier(mod = nil)
      return (@modifier or DEFAULT_MODIFIER) unless mod
      @modifier = mod
    end

    def key(key, mod = nil, &block)
      mod_mask = KEY_MODIFIERS[modifier]
      mod_mask |= KEY_MODIFIERS[mod] if mod
      @keys[[key, mod_mask]] = block
    end

    def on_init(&block)
      @on_init = block
    end

    def worker(*args, **options)
      if args.any?
        @worker = WORKERS[args.first].new(@display, @logger, options)
      else
        @worker ||= Workers::BlockingWorker.new(@display, @logger)
      end
    end

    def request_quit!
      @quit_requested = true
    end

    def run
      connect
      @layout.screens = @display.screens.each_with_object({}) do |e, m|
        m[e.id] = e.geo.dup
      end
      @on_init.call @display
      grab_keys
      @display.root.mask = ROOT_MASK
      worker.setup.each_event do |e|
        process_event e
        break if quit_requested?
      end
      disconnect
    end


    private

    def modifier_mask(mod)
      KEY_MODIFIERS[mod]
    end

    def quit_requested?
      !!@quit_requested
    end

    def connect
      @display.open
      Display.on_error proc { fail OtherWMRunningError }
      @display.listen_events INPUT_MASK
      @display.sync false
      Display.on_error proc { |*args| handle_error(*args) }
      @display.sync false
    end

    def disconnect
      @display.close
    end

    def grab_keys
      @keys.each do |k, v|
        key, mod = *k
        key = key.to_s.gsub /\AXK_/, ''
        @display.grab_key key, mod
      end
    end

    def process_event(event)
      return unless respond_to? handler = event_handler_method(event), true
      log_event event
      send handler, event
    end

    def event_handler_method(event)
      ('handle_%s' % event.type).to_sym
    end

    def log_event(event)
      fmt         = '> Event %s'
      complement  = case event.type
      when :destroy_notify, :expose, :key_press, :map_request, :unmap_notify
        "window: #{event.window}"
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

      log 'XEvent %s' % [event.type, complement].compact.join(' ')
    end

    def handle_configure_request(event)
      @manager.configure event.window
    end

    def handle_destroy_notify(event)
      @manager.destroy event.window
    end

    def handle_expose(event)
    end

    def handle_key_press(event)
      @action_handler.call @keys[["XK_#{event.key}".to_sym, event.modifier_mask]]
    end

    def handle_map_request(event)
      @manager.map event.window
    end

    def handle_property_notify(event)
    end

    def handle_unmap_notify(event)
      @manager.unmap event.window
    end

    def handle_error(req, resource_id, msg)
      @logger.error "XERROR: #{resource_id} #{req} #{msg}"
    end
  end
end
