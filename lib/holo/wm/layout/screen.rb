module Holo
  class WM
    class Layout
      class Screen
        extend Forwardable
        def_delegator :@tags, :current, :current_tag
        def_delegator :@tags, :current?, :current_tag?
        def_delegator :@tags, :remove, :remove
        def_delegator :current_tag, :suggest_geo, :suggest_geo

        attr_reader :bar, :tags

        def initialize(display, screen)
          @id       = screen.id
          @display  = display
          @geo      = screen.geo.dup
          @bar      = Bar.new(display, @geo).show
          @tags     = TagList.new(geo_for_new_tag)
        end

        def to_s
          'SCREEN #%d %s' % [@id, @geo]
        end

        def <<(client)
          current_tag << client
        end

        def tag_sel(tag_id)
          return unless tag_id != current_tag.id
          current_tag.hide
          tags.sel(tag_id).show
        end

        def tag_set(tag_id)
          return unless tag_id != current_tag.id && current_client
          current_client.hide
          tags.set tag_id, current_client.hide
        end

        def update_bar!(active)
          @bar.active = active
          @bar.update(tags, current_tag).blit
        end


        private

        def geo_for_new_tag
          @geo.dup.tap { |o| o.height -= @bar.height }
        end
      end
    end
  end
end
