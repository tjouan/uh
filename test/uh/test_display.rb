require 'test_helper'

module Uh; class UhDisplaySpec < UhSpec
  describe Display do
    subject { Display.new }

    describe '#check!' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.check! }
      end
    end

    describe '#close' do
      it 'closes the display' do
        subject.open
        subject.close
        _(subject).wont_be :opened?
      end
    end

    describe '#color_by_name' do
      it 'returns a color when display is opened' do
        subject.open
        _(subject.color_by_name 'rgb:42/42/42' ).must_be_instance_of Color
      end
    end

    describe '#create_pixmap' do
      it 'returns a color when display is opened' do
        subject.open
        _(subject.create_pixmap 320, 240).must_be_instance_of Pixmap
      end

      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.create_pixmap 320, 240 }
      end
    end

    describe '#each_event' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.each_event { } }
      end
    end

    describe '#fileno' do
      it 'returns the file descriptor of current connection' do
        subject.open
        _(subject.fileno).must_be_instance_of Fixnum
      end

      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.fileno }
      end
    end

    describe '#flush' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.flush }
      end
    end

    describe '#grab_key' do
      let(:modifier) { KEY_MODIFIERS[:mod1] }

      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.grab_key 'f', modifier }
      end

      it 'raises an error when given key is not a string' do
        subject.open
        assert_raises(TypeError) { subject.grab_key 42, modifier }
      end

      it 'raises an error when given key is invalid' do
        subject.open
        assert_raises ArgumentError do
          subject.grab_key 'invalid_key', modifier
        end
      end

      it 'raises an error when given modifier is not a valid mask' do
        subject.open
        assert_raises(TypeError) { subject.grab_key 'f', :invalid_mask }
      end
    end

    describe '#listen_events' do
      it 'raises an error when display is not opened' do
        assert_raises DisplayError do
          subject.listen_events Events::NO_EVENT_MASK
        end
      end
    end

    describe '#next_event' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.next_event }
      end
    end

    describe '#opened?' do
      it 'returns true when display is opened' do
        subject.open
        _(subject).must_be :opened?
      end

      it 'returns false when display is not opened' do
        _(subject).wont_be :opened?
      end
    end

    describe '#pending?' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.pending? }
      end
    end

    describe '#query_font' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.query_font }
      end
    end

    describe '#root' do
      it 'returns a window' do
        subject.open
        _(subject.root).must_be_instance_of Window
      end

      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.root }
      end
    end

    describe '#screens' do
      it 'returns an array of screens' do
        subject.open
        _(subject.screens[0]).must_be_instance_of Screen
      end

      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.screens }
      end
    end

    describe '#sync' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { subject.sync false }
      end
    end
  end
end; end
