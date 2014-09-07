require 'spec_helper'
require 'holo/wm'

module Holo
  class WM
    class Layout
      describe Col do
        let(:some_client)   { instance_spy Client }
        let(:other_client)  { instance_spy Client }
        subject(:col)       { described_class.new(0) << some_client }

        describe '#to_s' do
          it 'returns a representation as string' do
            expect(col.to_s).to match /COL.+#{col.id}.+#{col.geo.to_s}/
          end
        end

        describe '#<=>' do
          it 'compares cols with their id' do
            expect(col <=> described_class.new(42)).to eq -1
            expect(col <=> described_class.new(-42)).to eq 1
          end
        end

        describe '#first?' do
          context 'when id is 0' do
            it 'returns true' do
              expect(col.first?).to be true
            end
          end

          context 'when id is not 0' do
            it 'returns false' do
              expect(described_class.new(42).first?).to be false
            end
          end
        end

        describe '#suggest_geo' do
          it 'returns a copy of current geo' do
            expect(col.suggest_geo).to eq col.geo
            expect(col.suggest_geo).not_to be col.geo
          end
        end

        describe '#<<' do
          it 'hides current client' do
            col << other_client
            expect(some_client).to have_received :hide
          end

          it 'assigns new client geo' do
            col << other_client
            expect(other_client).to have_received(:geo=).with col.geo
          end

          it 'moveresizes new client' do
            col << other_client
            expect(other_client).to have_received :moveresize
          end

          it 'show new client' do
            col << other_client
            expect(other_client).to have_received :show
          end

          it 'returns itself' do
            expect(col << other_client).to be col
          end
        end

        describe '#remove' do
          before { col << other_client }

          it 'removes given client' do
            expect { col.remove other_client }
              .to change { col.clients_count }.from(2).to(1)
          end

          it 'shows current client' do
            expect(some_client).to receive :show
            col.remove other_client
          end
        end

        describe '#arrange!' do
          it 'assigns current geo to clients' do
            expect(some_client).to receive(:geo=).with col.geo
            col.arrange!
          end

          it 'moveresizes clients' do
            expect(some_client).to receive :moveresize
            col.arrange!
          end
        end

        describe '#show' do
          before { col << other_client }

          it 'shows current client' do
            expect(other_client).to receive :show
            col.show
          end

          it 'does not show non-current clients' do
            expect(some_client).not_to receive :show
            col.show
          end
        end

        describe '#hide' do
          before { col << other_client }

          it 'hides current client' do
            expect(other_client).to receive :hide
            col.hide
          end
        end

        describe '#client_sel_prev' do
          before { col << other_client }

          it 'hides current client' do
            expect(other_client).to receive :hide
            col.client_sel_prev
          end

          it 'selects previous client' do
            col.client_sel_prev
            expect(col.current_client).to be some_client
          end

          it 'shows selected client' do
            expect(some_client).to receive :show
            col.client_sel_prev
          end

          it 'focus selected client' do
            expect(some_client).to receive :focus
            col.client_sel_prev
          end
        end

        describe '#client_sel_next' do
          before { col << other_client }

          it 'hides current client' do
            expect(other_client).to receive :hide
            col.client_sel_next
          end

          it 'selects previous client' do
            col.client_sel_next
            expect(col.current_client).to be some_client
          end

          it 'shows selected client' do
            expect(some_client).to receive :show
            col.client_sel_next
          end

          it 'focus selected client' do
            expect(some_client).to receive :focus
            col.client_sel_next
          end
        end

        describe '#client_swap_prev' do
          it 'swaps clients' do
            expect(col.clients).to receive :swap_prev
            col.client_swap_prev
          end
        end

        describe '#client_swap_next' do
          it 'swaps clients' do
            expect(col.clients).to receive :swap_next
            col.client_swap_next
          end
        end
      end
    end
  end
end
