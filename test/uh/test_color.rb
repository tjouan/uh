require 'test_helper'

module Uh; class UhColorSpec < UhSpec
  describe Color do
    let(:dpy)   { Display.new.tap { |o| o.open } }
    let(:color) { 'rgb:42/42/42' }
    subject     { described_class.new dpy, color }

    describe '.new' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { described_class.new Display.new, color }
      end

      it 'raises an error when color name is invalid' do
        assert_raises ArgumentError do
          described_class.new dpy, 'invalid_color'
        end
      end

      it 'raises an error when color name is not a string' do
        assert_raises(TypeError) { described_class.new dpy, 42 }
      end
    end

    describe '#name' do
      it 'returns the color name' do
        _(subject.name).must_equal color
      end
    end
  end
end; end
