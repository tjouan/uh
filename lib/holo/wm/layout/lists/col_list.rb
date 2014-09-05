module Holo
  class WM
    class Layout
      module Lists
        class ColList < BaseList
          def initialize(*entries, &block)
            super *entries
            @on_update = block
          end

          def current_or_create
            current or (self.current = create 0)
          end

          def <<(col)
            super
            sort!
            renumber_cols
            @on_update.call col
          end

          def find_by_id(id)
            find { |col| col.id == id }
          end

          def find_or_create(id)
            find_by_id(id) or create(id)
          end

          def purge
            size_before = size
            return unless delete_if(&:empty?).size != size_before
            return @current_index = nil if empty?
            @current_index -= 1 unless current
            renumber_cols
            @on_update.call
          end


          private

          def create(id)
            Col.new(id).tap do |col|
              self << col
            end
          end

          def renumber_cols
            each_with_index { |col, i| col.id = i }
          end
        end
      end
    end
  end
end
