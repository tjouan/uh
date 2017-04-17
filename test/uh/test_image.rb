require 'test_helper'

module Uh; class UhImageSpec < UhSpec
  describe Image do
    let(:dpy)     { Display.new.tap &:open }
    let(:width)   { 16 }
    let(:height)  { 16 }
    let(:data)    { "\0" * width * height * 4 }
    subject       { described_class.new dpy, width, height, data }

    describe '.new' do
      it 'returns an image' do
        _(subject).must_be_instance_of Image
      end

      it 'raises an error when display is not opened' do
        assert_raises DisplayError do
          described_class.new Display.new, width, height, data
        end
      end
    end
  end
end; end
