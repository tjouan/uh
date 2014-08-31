module Holo
  class WM
    class Layout
      class Col
        WIDTH = 484

        extend Forwardable
        def_delegators :@clients, :empty?, :include?

        attr_accessor :id
        attr_reader   :geo, :clients, :current

        def initialize(id)
          @id       = id
          @geo      = Geo.new
          @clients  = []
          @current  = nil
        end

        def to_s
          'COL #%d %s' % [id, geo]
        end

        def current_client
          current ? clients[current] : nil
        end

        def current_client?(client)
          current_client == client
        end

        def first?
          id == 0
        end

        def <<(client)
          insert_client client
          client.geo = geo.dup
          client.moveresize
          current_client.hide if current_client
          @current = clients.index client
        end

        def remove(client)
          return unless index = clients.index(client)
          clients.delete_at index
          return unless clients.any?
          @current = index.zero? ? 0 : index - 1
          current_client.show
        end

        def arrange!
          clients.each do |c|
            c.geo = geo.dup
            c.moveresize
          end
        end

        def show
          current_client.show
        end

        def hide
          current_client.hide
        end

        def sel_prev
          sel :pred
        end

        def sel_next
          sel :succ
        end


        private

        def insert_client(client)
          if current_client
            clients.insert current + 1, client
          else
            clients << client
          end
        end

        def sel(direction)
          return unless clients.size >= 2
          old = current_client
          @current = current.send(direction) % clients.size
          current_client.show.focus
          old.hide
        end
      end
    end
  end
end
