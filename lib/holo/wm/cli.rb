module Holo
  class WM
    class CLI
      RC_PATH = "#{ENV['HOME']}/.holo/config.rb".freeze

      class << self
        def run!(arguments)
          new.run
        end
      end

      def initialize(wm: nil, rc_path: RC_PATH)
        @wm       = wm
        @rc_path  = rc_path
      end

      def run
        wm.run
      end

      def wm
        @wm ||= if FileTest.readable? @rc_path
          configure_wm
        else
          WM.default
        end
      end


      private

      def configure_wm
        WM.new.tap { |o| o.instance_eval File.read(@rc_path), @rc_path }
      end
    end
  end
end
