require 'holo/wm'

module Holo
  class WM
    class Layout
      module Lists
        describe ClientList do
          let(:clients)   { %i[foo bar baz] }
          subject(:list)  { described_class.new(*clients) }

          before { list.current = clients.first if clients.any? }

          describe '#<<' do
            before { list << :qux }

            it 'inserts given client after current one' do
              expect(list.entries).to eq %i[foo qux bar baz]
            end

            it 'sets given client as current' do
              expect(list.current).to eq :qux
            end

            context 'when list is empty' do
              let(:clients) { [] }

              it 'appends given client' do
                expect(list.entries).to eq [:qux]
              end

              it 'sets given client as current' do
                expect(list.current).to eq :qux
              end
            end
          end

          describe '#remove' do
            before do
              list.current = :bar
              list.remove :bar
            end

            it 'removes given client' do
              expect(list.entries).to eq %i[foo baz]
            end

            it 'sets the index to previous client' do
              expect(list.current).to eq :foo
            end
          end

          describe '#swap_prev' do
            before { list.current = :bar }

            it 'swaps current client with previous one' do
              list.swap_prev
              expect(list.entries).to eq %i[bar foo baz]
            end

            it 'keeps track of current client' do
              list.swap_prev
              expect(list.current).to eq :bar
            end

            context 'when current client is the first one' do
              before { list.current = :foo }

              it 'rotates clients' do
                list.swap_prev
                expect(list.entries).to eq %i[bar baz foo]
              end

              it 'keeps track of current client' do
                list.swap_prev
                expect(list.current).to eq :foo
              end
            end
          end

          describe '#swap_next' do
            before { list.current = :bar }

            it 'swaps current client with nextious one' do
              list.swap_next
              expect(list.entries).to eq %i[foo baz bar]
            end

            it 'keeps track of current client' do
              list.swap_next
              expect(list.current).to eq :bar
            end

            context 'when current client is the last one' do
              before { list.current = :baz }

              it 'rotates clients' do
                list.swap_next
                expect(list.entries).to eq %i[baz foo bar]
              end

              it 'keeps track of current client' do
                list.swap_next
                expect(list.current).to eq :baz
              end
            end
          end
        end
      end
    end
  end
end

