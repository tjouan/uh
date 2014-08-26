module Holo
  class WM
    class Layout
      class Col
        attr_reader :id, :clients, :current_client

        def initialize(id)
          @id             = id
          @clients        = []
          @current_client = nil
        end

        def to_s
          [
            'COL #%d' % id,
            clients.map { |e| '  %s' % e }.join($/)
          ].join $/
        end

        def current_client_index
          clients.index current_client
        end

        def visible_clients
          [current_client].compact
        end

        def include?(client)
          clients.include? client
        end

        def <<(client)
          clients << client
          @current_client = client
        end

        def remove(client)
          clients.reject! { |e| e == client}
          @current_client = clients.last
        end

        def sel_next
          sel :succ
        end

        def sel_prev
          sel :pred
        end


        private

        def sel(direction)
          new_index = current_client_index.send direction
          @current_client = clients[new_index % clients.size]
        end
      end
    end
  end
end
