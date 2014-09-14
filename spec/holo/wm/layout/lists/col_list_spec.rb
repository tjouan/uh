require 'holo/wm'

module Holo
  class WM
    class Layout
      module Lists
        describe ColList do
          let(:col)       { Col.new(0) }
          subject(:list)  { described_class.new(col) }

          before { list.current = col }

          describe '#current_or_create' do
            it 'returns the current col' do
              expect(list.current).to be col
            end

            context 'when no col is current' do
              subject(:list) { described_class.new }

              it 'creates a new col' do
                expect { list.current_or_create }.to change { list.size }.by 1
              end

              it 'returns the created col' do
                expect(list.current_or_create).to eq Col.new(0)
              end

              it 'sets the created col as the current one' do
                col = list.current_or_create
                expect(list.current).to be col
              end
            end
          end

          describe '#<<' do
            let(:other_col) { Col.new(-1) }

            it 'sorts cols' do
              list << other_col
              expect(list.entries).to eq [other_col, col]
            end

            it 'renumbers cols' do
              list << other_col
              expect(list.entries.map &:id).to eq [0, 1]
            end
          end

          describe '#find_by_id' do
            it 'returns a col given its id' do
              expect(list.find_by_id 0).to be col
            end
          end

          describe '#find_or_create' do
            context 'when matching col exists' do
              it 'returns the col' do
                expect(list.find_or_create 0).to be col
              end
            end

            context 'when no matching col exists' do
              it 'creates a new col' do
                expect { list.find_or_create 42 }.to change { list.size }.by 1
              end

              it 'returns the new col' do
                expect(list.find_or_create 42).to be list.entries.last
              end
            end
          end

          describe '#purge' do
            it 'removes empty cols' do
              list.purge
              expect(list).to be_empty
            end

            context 'when no col remains after purge' do
              it 'unsets current col' do
                list.purge
                expect(list.current).to be nil
              end
            end

            context 'when some cols remain after purge' do
              let(:other_col) { Col.new(1) }

              before do
                list << other_col
                list.current = other_col
                allow(col).to receive(:empty?) { false }
              end

              it 'selects previous col' do
                list.purge
                expect(list.current).to be col
              end

              it 'renumbers cols' do
                col.id = 42
                list.purge
                expect(list.current.id).to eq 0
              end
            end
          end
        end
      end
    end
  end
end
