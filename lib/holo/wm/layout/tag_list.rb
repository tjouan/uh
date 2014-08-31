module Holo
  class WM
    class Layout
      class TagList
        include Enumerable

        attr_reader :tags

        def initialize(*tags)
          @tags = tags
        end

        def <<(tag)
          tags << tag
          tags.sort_by! &:id
        end

        def each(&block)
          tags.each &block
        end

        def remove_client(client)
          tags.each { |t| t.remove client }
        end
      end
    end
  end
end
