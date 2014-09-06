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

          attr_reader :entries, :current_index

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

          def remove(object)
            @entries.each { |e| e.remove object }
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

          def set_next(object)
            set object, :succ
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


          private

          def set(object, direction)
            destination = @entries[@current_index.send(direction) % size]
            current.remove object
            destination << object
          end
        end
      end
    end
  end
end
