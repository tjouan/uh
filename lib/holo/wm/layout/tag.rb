module Holo
  class WM
    class Layout
      class Tag
        include Comparable

        extend Forwardable
        def_delegator :@cols, :current, :current_col
        def_delegator :@cols, :current?, :current_col?
        def_delegator :current_col, :suggest_geo, :suggest_geo

        attr_accessor :geo
        attr_reader   :id, :cols

        def initialize(id, geo = nil)
          @id   = id
          @geo  = geo
          @cols = Lists::ColList.new { arrange! }
        end

        def to_s
          'TAG #%d %s' % [id, geo]
        end

        def <=>(other)
          id.to_s <=> other.id.to_s
        end

        def current_client
          current_col and current_col.current_client
        end

        def <<(client)
          cols.current_or_create << client
        end

        def remove(client)
          return unless client_col = cols.find { |e| e.include? client }
          client_col.remove client
          cols.purge
        end

        def show
          cols.each &:show
          self
        end

        def hide
          cols.each &:hide
          self
        end

        def col_sel_prev
          col_sel :pred
        end

        def col_sel_next
          col_sel :succ
        end

        def col_set_prev
          col_set current_col, current_client, current_col.id.pred
        end

        def col_set_next
          col_set current_col, current_client, current_col.id.succ
        end


        private

        def arrange!
          return if cols.empty?
          cols.each do |col|
            col.geo.x       = geo.x + Col::WIDTH * col.id
            col.geo.y       = geo.y
            col.geo.width   = Col::WIDTH
            col.geo.height  = geo.height
          end
          cols.last.geo.width = geo.x + geo.width - cols.last.geo.x
          cols.each &:arrange!
        end

        def max_cols
          geo.width / Col::WIDTH
        end

        def col_sel(direction)
          return unless cols.size >= 2
          cols.sel direction
          current_client.focus
        end

        def col_set(source_col, client, dest_col_id)
          source_col.remove client
          dest_col = cols.find_or_create(dest_col_id).tap { |o| o << client }
          cols.purge
          cols.current = dest_col
        end
      end
    end
  end
end
