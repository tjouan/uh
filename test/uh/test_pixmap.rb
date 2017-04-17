require 'test_helper'

module Uh; class UhPixmapSpec < UhSpec
  describe Pixmap do
    let(:dpy)     { Display.new.tap &:open }
    let(:width)   { 320 }
    let(:height)  { 240 }
    subject       { described_class.new dpy, width, height }

    describe '.new' do
      it 'raises an error when display is not opened' do
        assert_raises DisplayError do
          described_class.new Display.new, width, height
        end
      end
    end

    describe '#draw_string' do
      it 'raises an error when given text is not a string' do
        assert_raises TypeError do
          subject.draw_string 42, 42, :not_a_string
        end
      end
    end
  end
end; end
