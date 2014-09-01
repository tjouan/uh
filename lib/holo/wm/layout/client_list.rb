module Holo
  class WM
    class Layout
      class ClientList
        extend Forwardable
        def_delegators  :@clients, :any?, :each, :empty?, :include?
        def_delegator   :current, :==, :current?

        attr_reader :clients

        def initialize
          @clients        = []
          @current_index  = nil
        end

        def current
          clients[@current_index] if @current_index
        end

        def <<(client)
          if current
            clients.insert @current_index + 1, client
          else
            clients << client
          end
          @current_index = clients.index client
        end

        def remove(client)
          clients.delete_at clients.index client
          @current_index -= 1 unless @current_index.zero?
        end

        def sel(direction)
          @current_index = @current_index.send(direction) % clients.size
        end
      end
    end
  end
end
