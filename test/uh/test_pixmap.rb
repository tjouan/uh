require 'test_helper'

module Uh; class UhPixmapSpec < UhSpec
  describe Pixmap do
    let(:dpy)     { Display.new.tap { |o| o.open } }
    let(:width)   { 320 }
    let(:height)  { 240 }
    subject       { described_class.new(dpy, width, height) }

    it 'is a pixmap' do
      _(subject).must_be_instance_of described_class
    end
  end
end; end
