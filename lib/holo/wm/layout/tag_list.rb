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
          tags.sort!
        end

        def each(&block)
          tags.each &block
        end

        def create(id, geo)
          Tag.new(id, geo).tap { |t| self << t }
        end

        def find_by_id(id)
          tags.find { |t| t.id == id }
        end

        def find_or_create(id, geo)
          find_by_id(id) or create(id, geo)
        end

        def remove_client(client)
          tags.each { |t| t.remove client }
        end
      end
    end
  end
end
