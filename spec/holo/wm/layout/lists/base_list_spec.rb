require 'spec_helper'
require 'holo/wm'

module Holo
  class WM
    class Layout
      module Lists
        describe BaseList do
          let(:entries)   { %i[foo bar baz] }
          subject(:list)  { described_class.new(*entries) }

          describe '#current' do
            context 'when no current entry is set' do
              it 'returns nil' do
                expect(list.current).to be nil
              end
            end

            context 'when a current entry is set' do
              before { list.current = :foo }

              it 'returns the current entry' do
                expect(list.current).to eq :foo
              end
            end
          end

          describe '#current=' do
            it 'changes the current index for given entry' do
              list.current = :bar
              expect(list.current_index).to eq entries.index :bar
            end
          end

          describe '#remove' do
            let(:entry)   { double 'entry' }
            let(:entries) { [entry] }

            it 'calls #remove on each entry' do
              expect(entry).to receive(:remove).with(:foo)
              list.remove :foo
            end
          end

          describe '#sel_prev' do
            before { list.current = :bar }

            it 'sets previous entry as the current one' do
              list.sel_prev
              expect(list.current).to eq :foo
            end

            context 'when current entry is the first one' do
              before { list.current = :foo }

              it 'sets last entry as the current one' do
                list.sel_prev
                expect(list.current).to eq :baz
              end
            end
          end

          describe '#sel_next' do
            before { list.current = :bar }

            it 'sets next entry as the current one' do
              list.sel_next
              expect(list.current).to eq :baz
            end

            context 'when current entry is the last one' do
              before { list.current = :baz }

              it 'sets first entry as the current one' do
                list.sel_next
                expect(list.current).to eq :foo
              end
            end
          end

          describe '#set_next' do
            let(:source)  { double('source entry').as_null_object }
            let(:dest)    { [] }
            let(:entries) { [source, dest] }

            before { list.current = source }

            it 'removes given object from current entry' do
              expect(source).to receive(:remove).with(:object)
              list.set_next :object
            end

            it 'appends given object to next entry' do
              list.set_next :object
              expect(dest.last).to eq :object
            end

            it 'does not change current entry' do
              expect { list.set_next :object }.not_to change { list.current }
            end
          end

          describe '#swap' do
            it 'swaps entries matched by given indexes' do
              list.swap 0, 1
              expect(list.entries).to eq %i[bar foo baz]
            end
          end

          describe '#rotate' do
            context 'succ direction' do
              it 'rotates entries' do
                list.rotate :pred
                expect(list.entries).to eq %i[bar baz foo]
              end
            end

            context 'pred direction' do
              it 'rotates entries' do
                list.rotate :succ
                expect(list.entries).to eq %i[baz foo bar]
              end
            end
          end
        end
      end
    end
  end
end
