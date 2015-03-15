require 'ostruct'
require 'test_helper'
require 'uh/wm'

module Uh
  class WM
    describe Client do
      let(:geo)     { Geo.new(0, 0, 1024, 768) }
      let(:window)  { OpenStruct.new(name: 'win name', wclass: 'win class') }
      subject       { Client.new(window) }

      before { subject.geo = geo }

      it 'is hidden' do
        assert subject.hidden?
      end

      describe '#name' do
        it 'returns the window name' do
          assert_equal 'win name', subject.name
        end
      end

      describe '#wclass' do
        it 'returns the window class' do
          assert_equal 'win class', subject.wclass
        end
      end

      describe '#update_window_properties' do
        it 'updates the window name' do
          window.name = 'new name'
          assert_equal 'new name', subject.name
        end

        it 'updates the window class' do
          window.wclass = 'new class'
          assert_equal 'new class', subject.wclass
        end
      end

      describe '#configure' do
        let(:window) { Minitest::Mock.new }

        before { window.expect :configure, window, [geo] }

        it 'configures the window with client geo' do
          subject.configure
          window.verify
        end

        it 'returns self' do
          assert_same subject, subject.configure
        end
      end

      describe '#moveresize' do
        let(:window) { Minitest::Mock.new }

        before { window.expect :moveresize, window, [geo] }
        it 'moveresizes the window with client geo' do
          subject.moveresize
          window.verify
        end

        it 'returns self' do
          assert_same subject, subject.moveresize
        end
      end

      describe '#show' do
        let(:window) { Minitest::Mock.new }

        before { window.expect :map, window }

        it 'maps the window' do
          subject.show
          window.verify
        end

        it 'is not hidden anymore' do
          subject.show
          refute subject.hidden?
        end

        it 'returns self' do
          assert_same subject, subject.show
        end
      end

      describe '#hide' do
        let(:window) { Minitest::Mock.new }

        before { window.expect :unmap, window }

        it 'unmaps the window' do
          subject.hide
          window.verify
        end

        it 'is stays hidden' do
          subject.hide
          assert subject.hidden?
        end

        it 'returns self' do
          assert_same subject, subject.hide
        end
      end

      describe '#focus' do
        let(:window) { Minitest::Mock.new }

        before do
          window.expect :raise, window
          window.expect :focus, window
        end

        it 'raises and focuses the window' do
          subject.focus
          window.verify
        end

        it 'returns self' do
          assert_same subject, subject.focus
        end
      end

      describe '#kill' do
        let(:window)    { Minitest::Mock.new }
        let(:protocols) { [] }

        before { window.expect :icccm_wm_protocols, protocols }

        it 'kills the window' do
          window.expect :kill, window
          subject.kill
          window.verify
        end

        it 'returns self' do
          window.expect :kill, window
          assert_same subject, subject.kill
        end

        context 'when window supports icccm wm delete' do
          let(:protocols) { [:WM_DELETE_WINDOW] }

          it 'icccm deletes the window' do
            window.expect :icccm_wm_delete, window
            subject.kill
            window.verify
          end
        end
      end

      describe '#kill!' do
        let(:window) { Minitest::Mock.new }

        before { window.expect :kill, window }

        it 'kills the window' do
          subject.kill!
          window.verify
        end

        it 'returns self' do
          assert_same subject, subject.kill!
        end
      end
    end
  end
end
