require 'test_helper'

describe Holo::Geo do
  subject { Holo::Geo.new(0, 0, 640, 480) }

  describe '.new' do
    it 'raises error when invalid width is given' do
      assert_raises(Holo::ArgumentError) { Holo::Geo.new(0, 0, 0, 480) }
    end

    it 'raises error when invalid height is given' do
      assert_raises(Holo::ArgumentError) { Holo::Geo.new(0, 0, 640, 0) }
    end
  end

  %w[width height].each do |dimension|
    describe "##{dimension}=" do
      it 'assigns given value' do
        subject.send "#{dimension}=", 42
        assert_equal 42, subject.send(dimension)
      end

      it 'raises error when 0 is given' do
        assert_raises(Holo::ArgumentError) { subject.send "#{dimension}=", 0 }
      end

      it 'raises error when negative value is given' do
        assert_raises(Holo::ArgumentError) { subject.send "#{dimension}=", -42 }
      end
    end
  end
end
