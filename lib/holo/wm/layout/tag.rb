module Holo
  class WM
    class Layout
      class Tag
        attr_reader :id, :geo, :cols, :current_col

        def initialize(id, geo)
          @id           = id
          @geo          = geo
          @cols         = [Col.new(0, geo.dup)]
          @current_col  = cols.last
        end

        def to_s
          'TAG #%d %s' % [id, geo]
        end

        def current_client
          current_col.current_client
        end

        def clients
          cols.inject([]) { |m, e| m + e.clients }
        end

        def visible_clients
          cols.inject([]) { |m, e| m + e.visible_clients }
        end

        def <<(client)
          current_col << client
        end

        def remove(client)
          cols.each { |e| e.remove client }
        end

        def sel_next
          current_col.sel_next
        end

        def sel_prev
          current_col.sel_prev
        end

        def col_set_next
          visible_clients.each(&:hide)
          client = current_col.current_client
          current_col.remove client
          find_or_create_col(current_col.id + 1) << client
          visible_clients.each(&:show)
        end


        private

        def find_or_create_col(id)
          col = cols.find { |e| e.id == id }
          cols << col = Col.new(id, geo.dup) unless col
          col
        end
      end
    end
  end
end
