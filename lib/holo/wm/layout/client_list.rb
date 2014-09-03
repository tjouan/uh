module Holo
  class WM
    class Layout
      class ClientList
        extend Forwardable
        def_delegators  :@clients, :any?, :each, :empty?, :include?, :size
        def_delegator   :current, :==, :current?

        attr_reader :clients, :current_index

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
          @current_index = @current_index.send(direction) % size
        end

        def set(direction)
          other_index = @current_index.send(direction)
          if other_index.between? 0, size - 1
            swap @current_index, other_index
            @current_index = other_index
          else
            rotate direction
            @current_index = other_index % size
          end
        end


        private

        def swap(a, b)
          clients[a], clients[b] = clients[b], clients[a]
        end

        def rotate(direction)
          case direction
          when :pred then @clients = @clients.push    @clients.shift
          when :succ then @clients = @clients.unshift @clients.pop
          end
        end
      end
    end
  end
end
