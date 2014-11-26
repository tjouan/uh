require 'tempfile'
require 'holo/wm'

module Holo
  class WM
    describe CLI do
      let(:wm)        { WM.new }
      subject(:cli)   { described_class.new wm: wm }

      describe '#run' do
        it 'runs the window manager' do
          expect_any_instance_of(WM).to receive :run
          cli.run
        end
      end

      describe '#wm' do
        it 'returns the assigned WM' do
          expect(cli.wm).to be wm
        end

        context 'when no WM is assigned' do
          context 'when RC file exists' do
            it 'returns a WM configured with RC file content' do
              Tempfile.create('holo-spec') do |f|
                f.puts "modifier :some_modifier"
                f.flush
                cli = described_class.new rc_path: f.path
                expect(cli.wm.modifier).to eq :some_modifier
              end
            end
          end

          context 'when RC file does not exists' do
            subject(:cli) { described_class.new rc_path: 'NO_RC_FILE' }

            it 'returns the default WM' do
              expect(cli.wm.keys.keys).to eq WM.default.keys.keys
            end
          end
        end
      end
    end
  end
end
