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
      end
    end
  end
end
