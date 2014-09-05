module Holo
  class WM
    class Layout
      module Lists
        class BaseList
          extend Forwardable
          def_delegators  :@entries, :<<, :delete_at, :delete_if, :each,
            :each_with_index, :empty?, :find, :include?, :index, :inject,
            :insert, :last, :size, :sort!
          def_delegator :current, :==, :current?

          attr_reader :current_index

          def initialize(*entries)
            @entries        = entries
            @current_index  = nil
          end

          def current
            @entries[@current_index] if @current_index
          end

          def current=(entry)
            @current_index = index entry
          end

          def remove(entry)
            @entries.each { |e| e.remove entry }
          end

          def sel_prev
            sel :pred
          end

          def sel_next
            sel :succ
          end

          def sel(direction)
            @current_index = @current_index.send(direction) % size
          end

          def set_next(entry)
            set entry, :succ
          end


          private

          def set(entry, direction)
            destination = @entries[@current_index.send(direction) % size]
            current.remove entry
            destination << entry
          end

          def swap(a, b)
            @entries[a], @entries[b] = @entries[b], @entries[a]
          end

          def rotate(direction)
            case direction
            when :pred then @entries = @entries.push    @entries.shift
            when :succ then @entries = @entries.unshift @entries.pop
            end
          end
        end
      end
    end
  end
end
