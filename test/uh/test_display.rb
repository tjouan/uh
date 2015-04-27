require 'test_helper'

module Uh; class UhDisplaySpec < UhSpec
  describe Display do
    subject { Display.new }

    describe '#color_by_name' do
      it 'returns a color when display is opened' do
        subject.open
        _(subject.color_by_name 'rgb:42/42/42' ).must_be_instance_of Color
      end
    end

    describe '#grab_key' do
      let(:modifier) { KEY_MODIFIERS[:mod1] }

      it 'raises an error when given key is not a string' do
        assert_raises(TypeError) { subject.grab_key 42, modifier }
      end

      it 'raises an error when given key is invalid' do
        assert_raises(ArgumentError) { subject.grab_key 'invalid_key', modifier }
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
  end
end; end
