module Holo
  class WM
    def initialize

    end

    def connect

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
