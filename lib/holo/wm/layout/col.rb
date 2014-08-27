module Holo
  class WM
    class Layout
      class Col
        WIDTH = 484

        attr_accessor :id
        attr_reader   :geo, :clients, :current

        def initialize(id, geo)
          @id       = id
          @geo      = geo
          @clients  = []
          @current  = nil
        end

        def to_s
          'COL #%d %s' % [id, geo]
        end

        def current_client
          current ? clients[current] : nil
        end

        def visible_clients
          [current_client].compact
        end

        def empty?
          clients.empty?
        end

        def include?(client)
          clients.include? client
        end

        def <<(client)
          insert_client client
          client.geo = geo.dup
          client.moveresize.show.focus
          current_client.hide if current_client
          @current = clients.index client
        end

        def insert_client(client)
          if current_client
            clients.insert current + 1, client
          else
            clients << client
          end
        end

        def remove(client)
          return unless index = clients.index(client)
          clients.delete_at index
          return unless clients.any? && index == current
          @current = index.zero? ? 0 : index - 1
          current_client.show.focus
        end

        def arrange_clients
          clients.each do |c|
            c.geo = geo.dup
            c.moveresize
          end
        end

        def sel_next
          sel :succ
        end

        def sel_prev
          sel :pred
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
