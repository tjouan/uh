require 'test_helper'

module Uh; class UhFontSpec < UhSpec
  describe Font do
    let(:dpy)   { Display.new.tap { |o| o.open } }
    subject     { described_class.new(dpy) }

    describe '#width' do
      it 'returns a valid font width' do
        _(subject.width).must_be :>, 1
      end
    end

    describe '#ascent' do
      it 'returns a valid font ascent' do
        _(subject.ascent).must_be :>, 1
      end
    end

    describe '#descent' do
      it 'returns a valid font descent' do
        _(subject.descent).must_be :>, 1
      end
    end
  end
end; end
