require 'test_helper'

module Uh; class UhColorSpec < UhSpec
  describe Color do
    let(:dpy)   { Display.new.tap { |o| o.open } }
    let(:color) { 'rgb:42/42/42' }
    subject     { described_class.new(dpy, color) }

    it 'is a color' do
      _(subject).must_be_instance_of described_class
    end

    describe '.new' do
      it 'raises an error when display is not opened' do
        assert_raises(DisplayError) { described_class.new(Display.new, color) }
      end

      it 'raises an error when color name is invalid' do
        assert_raises(ArgumentError) do
          described_class.new(dpy, 'invalid_color')
        end
      end
    end
  end
end; end
