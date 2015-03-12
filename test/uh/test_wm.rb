require 'test_helper'
require 'uh/wm'

module Uh
  describe WM do
    subject { WM.new(Object.new) }

    it 'has no rules' do
      assert_empty subject.rules
    end

    describe '#rule' do
      let(:block) { proc { } }

      it 'registers a new rule' do
        subject.rule 'client', &block
        assert_equal 1, subject.rules.size
      end

      it 'transforms the given selector as a regexp' do
        subject.rule 'client', &block
        assert_equal /\Aclient/i, subject.rules.keys[0]
      end

      it 'assigns the given block' do
        subject.rule 'client', &block
        assert_includes subject.rules.values, block
      end

      it 'accepts an array of selectors' do
        subject.rule %w[foo bar], &block
        assert_equal [/\Afoo/i, /\Abar/i], subject.rules.keys
      end
    end
  end
end
