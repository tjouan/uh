module Holo
  class WM
    class Layout
      class Col
        WIDTH = 484

        include Comparable

        extend Forwardable
        def_delegators  :@clients, :empty?, :include?
        def_delegator   :@clients, :current, :current_client
        def_delegator   :@clients, :current?, :current_client?
        def_delegator   :@clients, :current_index, :current_client_index
        def_delegator   :@clients, :size, :clients_count

        attr_accessor :id
        attr_reader   :geo, :clients

        def initialize(id)
          @id       = id
          @geo      = Geo.new
          @clients  = ClientList.new
        end

        def to_s
          'COL #%d %s' % [id, geo]
        end

        def <=>(other)
          id <=> other.id
        end

        def first?
          id == 0
        end

        def suggest_geo
          geo.dup
        end

        def <<(client)
          current_client.hide if current_client
          clients << client
          client.geo = geo.dup
          client.moveresize
          client.show
        end

        def remove(client)
          clients.remove client
          current_client.show if current_client
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

        def client_sel_prev
          client_sel :pred
        end

        def client_sel_next
          client_sel :succ
        end

        def client_swap_prev
          clients.set :pred
        end

        def client_swap_next
          clients.set :succ
        end


        private

        def client_sel(direction)
          current_client.hide
          clients.sel direction
          current_client.show.focus
        end
      end
    end
  end
end
