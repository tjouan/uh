require 'test_helper'

module Uh; class UhWindowSpec < UhSpec
  describe Window do
    let(:dpy) { Display.new.tap { |o| o.open } }
    subject   { described_class.new dpy, dpy.root.id }

    describe '#name=' do
      it 'raises an error when given argument is not a string' do
        assert_raises(TypeError) { subject.name = :not_a_string }
      end
    end
  end
end; end
