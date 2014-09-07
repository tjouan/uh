require 'holo/wm'

module Holo
  class WM
    class Layout
      describe Tag do
        let(:client)        { instance_spy Client }
        let(:other_client)  { instance_spy Client }
        let(:geo)           { Geo.new(0, 0, 1024, 768) }
        subject(:tag)       { described_class.new(1, geo) }

        describe '#to_s' do
          it 'returns a representation as string' do
            expect(tag.to_s)
              .to match /TAG.+#{tag.id}.+#{Regexp.quote(geo.to_s)}/
          end
        end

        describe '#<=>' do
          it 'compares tags with their id' do
            expect(tag <=> described_class.new(42)).to eq -1
            expect(tag <=> described_class.new(-42)).to eq 1
          end
        end

        describe '#current_client' do
          context 'when tag has no client' do
            it 'returns nil' do
              expect(tag.current_client).to be nil
            end
          end

          context 'when tag has a client' do
            before { tag << client }

            it 'returns the client' do
              expect(tag.current_client).to be client
            end
          end
        end

        describe '#suggest_geo' do
          context 'when tag has no col' do
            it 'returns tag geo' do
              expect(tag.suggest_geo).to be geo
            end
          end

          context 'when tag has a col' do
            before { tag << client }

            it 'returns current col geo' do
              expect(tag.suggest_geo).to eq tag.current_col.suggest_geo
            end
          end
        end

        describe '#<<' do
          it 'adds given client to current col' do
            tag << client
            expect(tag.current_col).to include client
          end
        end

        describe '#remove' do
          before { tag << client << other_client }

          it 'removes given client from cols' do
            tag.remove other_client
            expect(tag.current_col).not_to include other_client
          end

          it 'purges empty cols' do
            tag.col_set_next
            expect { tag.remove other_client }
              .to change { tag.cols.size }.from(2).to(1)
          end
        end

        describe '#show' do
          before { tag << client }

          it 'shows cols' do
            expect(tag.current_col).to receive :show
            tag.show
          end
        end

        describe '#hide' do
          before { tag << client }

          it 'hides cols' do
            expect(tag.current_col).to receive :hide
            tag.hide
          end
        end

        describe '#col_sel_prev' do
          before do
            tag << client << other_client
            tag.col_set_next
          end

          it 'selects previous col' do
            expect { tag.col_sel_prev }.to change { tag.current_col }
              .from(tag.cols.last)
              .to(tag.cols.first)
          end
        end

        describe '#col_sel_next' do
          before do
            tag << client << other_client
            tag.col_set_next
          end

          it 'selects next col' do
            expect { tag.col_sel_next }.to change { tag.current_col }
              .from(tag.cols.last)
              .to(tag.cols.first)
          end
        end

        describe '#col_set_prev' do
          before { tag << other_client << client }

          it 'creates a new col' do
            expect { tag.col_set_prev }.to change { tag.cols.size }.by 1
          end

          it 'moves current client to the new col' do
            tag.col_set_prev
            expect(tag.cols.first).to include client
          end

          it 'removes current client from its origin col' do
            tag.col_set_prev
            expect(tag.cols.last).not_to include client
          end

          it 'leaves other clients in their origin col' do
            tag.col_set_prev
            expect(tag.cols.last).to include other_client
          end

          it 'sets the destination col as the current one' do
            tag.col_set_prev
            expect(tag.current_col).to be tag.cols.first
          end

          context 'when destination col exists' do
            before { tag.col_set_next }

            it 'purges the emptied col' do
              expect { tag.col_set_prev }.to change { tag.cols.size }.by -1
            end
          end
        end
      end
    end
  end
end
