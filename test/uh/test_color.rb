require 'test_helper'

module Uh; class UhColorSpec < UhSpec
  describe Color do
    let(:dpy)   { Display.new.tap { |o| o.open } }
    let(:color) { 'rgb:42/42/42' }
    subject     { described_class.new(dpy, color) }

    it 'is a color' do
      _(subject).must_be_instance_of described_class
    end
  end
end; end
