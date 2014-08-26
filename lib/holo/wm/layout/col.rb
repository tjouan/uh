module Holo
  class WM
    class Layout
      class Col
        attr_reader :id, :geo, :clients, :current_client

        def initialize(id, geo)
          @id             = id
          @geo            = geo
          @clients        = []
          @current_client = nil
        end

        def to_s
          'COL #%d %s' % [id, geo]
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
          insert_client client
          client.geo = geo.dup
          client.moveresize
          client.show
          client.focus
          current_client.hide if current_client
          @current_client = client
        end

        def insert_client(client)
          if current_client
            clients.insert current_client_index + 1, client
          else
            clients << client
          end
        end

        def remove(client)
          return unless clients.include? client
          clients.reject! { |e| e == client}
          @current_client = clients.last
          current_client.show if current_client
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