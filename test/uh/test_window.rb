require 'test_helper'

module Uh; class UhWindowSpec < UhSpec
  describe Window do
    let(:dpy) { Display.new.tap &:open }
    subject   { described_class.new dpy, dpy.root.id }

    describe '#to_s' do
      it 'returns the window identifier as a string' do
        _(subject.to_s).must_match /\d+/
      end
    end

    describe '#==' do
      let(:geo)           { Geo.new(0, 0, 320, 240) }
      let(:window_other)  { dpy.create_window geo }

      it 'returns true when given same window' do
        _(subject.== subject).must_equal true
      end

      it 'returns false when given another window' do
        _(subject.== window_other).must_equal false
      end
    end

    describe '#name=' do
      it 'raises an error when given argument is not a string' do
        assert_raises(TypeError) { subject.name = :not_a_string }
      end
    end
  end
end; end
