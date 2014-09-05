module Holo
  class WM
    class Layout
      module Lists
        class ColList
          extend Forwardable
          def_delegators  :@cols, :each, :empty?, :find, :last, :size
          def_delegator   :current, :==, :current?

          def initialize(&block)
            @cols           = []
            @current_index  = nil
            @on_update      = block
          end

          def current
            @cols[@current_index] if @current_index
          end

          def current=(col)
            @current_index = @cols.index col
          end

          def current_or_create
            current or create 0, set_current: true
          end

          def <<(col)
            @cols << col
            @cols.sort!
            renumber_cols
            @on_update.call col
          end

          def find_by_id(id)
            @cols.find { |col| col.id == id }
          end

          def find_or_create(id)
            find_by_id(id) or create(id)
          end

          def purge
            size_before = @cols.size
            return unless @cols.delete_if(&:empty?).size != size_before
            return @current_index = nil if @cols.empty?
            @current_index -= 1 unless current
            renumber_cols
            @on_update.call
          end

          def sel(direction)
            @current_index = @current_index.send(direction) % @cols.size
          end


          private

          def create(id, set_current: false)
            Col.new(id).tap do |col|
              self << col
              @current_index = @cols.index col if set_current
            end
          end

          def renumber_cols
            @cols.each_with_index { |col, i| col.id = i }
          end
        end
      end
    end
  end
end
