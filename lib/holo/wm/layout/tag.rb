module Holo
  class WM
    class Layout
      class Tag
        include Comparable

        attr_accessor :geo
        attr_reader   :id, :cols, :current_col

        def initialize(id, geo = nil)
          @id           = id
          @geo          = geo
          @cols         = []
          @current_col  = nil
        end

        def to_s
          'TAG #%d %s' % [id, geo]
        end

        def <=>(other)
          id <=> other.id
        end

        def current_client
          current_col and current_col.current_client
        end

        def <<(client)
          @current_col = create_col 0, arrange: true unless current_col
          current_col << client
        end

        def remove(client)
          return unless client_col = find_col_by_client(client)
          client_col.remove client
          delete_col! client_col if client_col.empty?
          return unless current_col? client_col
          @current_col = find_col current_col.id, current_col.id - 1
        end

        def show
          cols.each &:show
          self
        end

        def hide
          cols.each &:hide
          self
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

        def col_set_prev
          return if current_col.first?
          col_set current_col, current_client, :pred
        end

        def col_set_next
          return if current_col.id == max_col_id
          col_set current_col, current_client, :succ
        end


        private

        def current_col?(col)
          current_col == col
        end

        def col_sel(direction)
          return unless cols.size >= 2
          new_current_col = find_col current_col.id.send direction
          return unless new_current_col
          @current_col = new_current_col
          current_client.focus
        end

        def col_set(client_col, client, direction)
          client_col.remove client
          dest_col = find_or_create_col(
            client_col.id.send(direction),
            arrange: true
          )
          delete_col! client_col if client_col.empty?
          dest_col << client
          @current_col = dest_col
        end

        def create_col(id, arrange: false)
          Col.new(id).tap do |o|
            cols << o
            arrange! if arrange
          end
        end

        def col_id?(id)
          cols.any? { |e| e.id == id }
        end

        def find_col(*ids)
          ids.inject(nil) { |m, id| m || cols.find { |e| e.id == id } }
        end

        def find_col_by_client(client)
          cols.find { |e| e.include? client }
        end

        def find_or_create_col(id, arrange: false)
          col_id?(id) ? find_col(id) : create_col(id, arrange: arrange)
        end

        def delete_col(col, arrange: false)
          cols.reject! { |e| e == col }
          return unless cols.any?
          renumber_cols
          arrange! if arrange
        end

        def delete_col!(col)
          delete_col col, arrange: true
          @current_col = nil if cols.empty?
        end

        def renumber_cols
          cols.each_with_index { |col, i| col.id = i }
        end

        def arrange!
          cols.each do |col|
            col.geo.x       = Col::WIDTH * col.id
            col.geo.y       = geo.y
            col.geo.width   = Col::WIDTH
            col.geo.height  = geo.height
          end
          cols.last.geo.width = geo.width - cols.last.geo.x
          cols.each(&:arrange!)
        end

        def max_cols
          geo.width / Col::WIDTH
        end

        def max_col_id
          max_cols - 1
        end
      end
    end
  end
end
