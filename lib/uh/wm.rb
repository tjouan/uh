require 'forwardable'
require 'logger'

require 'uh/wm/action_handler'
require 'uh/wm/client'
require 'uh/wm/manager'
require 'uh/wm/workers/base_worker'
require 'uh/wm/workers/blocking_worker'
require 'uh/wm/workers/multiplexing_worker'

module Uh
  class WM
    include Events

    LOGGER_FORMAT_STR = "%s.%03i %s: %s\n".freeze
    LOGGER_FORMATER   = proc do |severity, datetime, progname, message|
      LOGGER_FORMAT_STR % [
        datetime.strftime('%FT%T'),
        datetime.usec / 1000,
        severity[0..0],
        message
      ]
    end
    LOGGER_LEVEL      = Logger::INFO
    LOGGER_DEBUG_ENV  = 'UH_DEBUG'.freeze

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
    def_delegators :@manager, :on_configure, :on_manage, :on_unmanage,
      :on_change
    def_delegator :@logger, :info, :log
    def_delegator :@logger, :error, :log_error

    attr_reader :actions, :keys, :rules

    def initialize(layout)
      @layout   = layout
      @display  = Display.new
      @logger   = Logger.new($stdout).tap do |o|
        o.level     = ENV.key?(LOGGER_DEBUG_ENV) ? Logger::DEBUG : LOGGER_LEVEL
        o.formatter = LOGGER_FORMATER
      end
      @manager  = Manager.new(@logger)
      @actions  = ActionHandler.new(self, @manager, @layout)
      @keys     = {}
      @rules    = {}
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

    def rule(selectors = '', &block)
      [*selectors].each do |selector|
        @rules[/\A#{selector}/i] = block
      end
    end

    def on_init(&block)
      @on_init = block
    end

    def on_expose(&block)
      @on_expose = block
    end

    def worker(*args, **options)
      @worker = WORKERS[args.first].new(@display, @logger, options)
    end

    def request_quit!
      @quit_requested = true
    end

    def connect
      @display.open
      Display.on_error proc { fail OtherWMRunningError }
      @display.listen_events INPUT_MASK
      @display.sync false
      Display.on_error proc { |*args| handle_error(*args) }
      @display.sync false
      @display.root.mask = ROOT_MASK
      @worker.setup
      @on_init.call @display if @on_init
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
      @display.sync false
    end

    def run_until(&block)
      @worker.each_event do |e|
        process_event e
        break if block.call
      end
    end

    def run
      run_until { quit_requested? }
    end


    private

    def modifier_mask(mod)
      KEY_MODIFIERS[mod]
    end

    def quit_requested?
      !!@quit_requested
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
      complement = case event.type
      when :destroy_notify, :expose, :key_press, :map_request, :property_notify
        "window: #{event.window}"
      when :configure_request
        '%s, above: #%d, detail: #%d, value_mask: #%d' % [
          Geo.format_xgeometry(event.x, event.y, event.width, event.height),
          event.above_window_id,
          event.detail,
          event.value_mask
        ]
      when :unmap_notify
        "window: #{event.window}, event_window: #{event.event_window}"
      end

      log [
        'XEvent', event.type,
        event.send_event ? 'SENT' : nil,
        complement
      ].compact.join(' ')
    end

    def handle_configure_request(event)
      @manager.configure event.window
    end

    def handle_destroy_notify(event)
      @manager.destroy event.window
    end

    def handle_expose(event)
      @on_expose.call event.window if @on_expose
    end

    def handle_key_press(event)
      actions.call @keys[["XK_#{event.key}".to_sym, event.modifier_mask]]
    end

    def handle_map_request(event)
      if client = @manager.map(event.window)
        @display.listen_events event.window, PROPERTY_CHANGE_MASK
        @rules.each do |selector, action|
          if client.wclass =~ selector
            actions.call action
          end
        end
      end
    end

    def handle_property_notify(event)
      @manager.update_properties event.window
    end

    def handle_unmap_notify(event)
      @manager.unmap event.window
    end

    def handle_error(req, resource_id, msg)
      @logger.error "XERROR: #{resource_id} #{req} #{msg}"
    end
  end
end
