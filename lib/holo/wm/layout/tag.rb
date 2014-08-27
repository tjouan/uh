module Holo
  class WM
    class Layout
      class Tag
        attr_reader :id, :geo, :cols, :current

        def initialize(id, geo)
          @id       = id
          @geo      = geo
          @cols     = []
          @current  = nil
        end

        def to_s
          'TAG #%d %s' % [id, geo]
        end

        def current_col
          current ? find_col(current) : nil
        end

        def current?(col)
          col.id == current
        end

        def current_client
          current_col and current_col.current_client
        end

        def visible_clients
          cols.inject([]) { |m, e| m + e.visible_clients }
        end

        def <<(client)
          @current = create_col(0).id unless current_col
          current_col << client
        end

        def remove(client)
          client_col = find_col_by_client client
          client_col.remove client
          delete_col client_col if client_col.empty?
          return @current = nil if cols.empty?
          renumber_cols
          arrange_cols
          return unless current? client_col
          @current = (find_col(current) or find_col(current - 1)).id
        end

        def arrange_cols
          cols.each do |col|
            col.geo.x     = Col::WIDTH * col.id
            col.geo.width = Col::WIDTH
          end
          cols.last.geo.width = geo.width - cols.last.geo.x
          cols.each(&:arrange_clients)
        end

        def renumber_cols
          cols.each_with_index { |col, i| col.id = i }
        end

        def sel_prev
          current_col.sel_prev
        end

        def sel_next
          current_col.sel_next
        end

        def col_sel_prev
          col_sel :pred
        end

        def col_sel_next
          col_sel :succ
        end

        def col_sel(direction)
          return unless cols.size >= 2
          new_current_col = find_col current.send direction
          return unless new_current_col
          @current = new_current_col.id
          current_client.focus
        end

        def col_set_prev
          col_set current_client, :pred
        end

        def col_set_next
          col_set current_client, :succ
        end

        def col_set(client, direction)
          current_col.remove client
          @current = find_or_create_col(current_col.id.send direction).id
          current_col << client
          arrange_cols
        end


        private

        def create_col(id)
          Col.new(id, geo.dup).tap { |o| cols << o }
        end

        def col?(id)
          cols.any? { |e| e.id == id }
        end

        def find_col(id)
          cols.find { |e| e.id == id }
        end

        def find_col_by_client(client)
          cols.find { |e| e.include? client }
        end

        def find_or_create_col(id)
          col?(id) ? find_col(id) : create_col(id)
        end

        def delete_col(col)
          cols.reject! { |e| e == col }
        end
      end
    end
  end
end
