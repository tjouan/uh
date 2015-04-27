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
  end
end; end
