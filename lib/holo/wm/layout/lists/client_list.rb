module Holo
  class WM
    class Layout
      module Lists
        class ClientList < BaseList
          def <<(client)
            if current then insert current_index + 1, client else super end
            @current_index = index client
          end

          def remove(client)
            delete_at index client
            @current_index -= 1 unless current_index.zero?
          end

          def set(direction)
            other_index = current_index.send direction
            if other_index.between? 0, size - 1
              swap current_index, other_index
              @current_index = other_index
            else
              rotate direction
              @current_index = other_index % size
            end
          end
        end
      end
    end
  end
end
