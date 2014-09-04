module Holo
  class WM
    class Layout
      class TagList
        FIRST_TAG_ID = 1

        include Enumerable

        extend Forwardable
        def_delegator :current, :==, :current?

        attr_accessor :current
        attr_reader   :tags

        def initialize(*tag_args)
          @tag_args = tag_args
          @current  = Tag.new(FIRST_TAG_ID, *tag_args)
          @tags     = [@current]
        end

        def <<(tag)
          tags << tag
          tags.sort!
        end

        def each(&block)
          tags.each &block
        end

        def create(id)
          Tag.new(id, *@tag_args).tap { |t| self << t }
        end

        def find_by_id(id)
          tags.find { |t| t.id == id }
        end

        def find_or_create(id)
          find_by_id(id) or create(id)
        end

        def remove(client)
          tags.each { |t| t.remove client }
        end

        def sel(id)
          @current = find_or_create id
        end

        def set(id, client)
          @current.remove client
          find_or_create(id) << client
        end
      end
    end
  end
end
