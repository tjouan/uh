require 'test_helper'

describe Uh::Geo do
  subject { Uh::Geo.new(0, 0, 640, 480) }

  describe '.new' do
    it 'raises error when invalid width is given' do
      assert_raises(Uh::ArgumentError) { Uh::Geo.new(0, 0, 0, 480) }
    end

    it 'raises error when invalid height is given' do
      assert_raises(Uh::ArgumentError) { Uh::Geo.new(0, 0, 640, 0) }
    end
  end

  describe '.format_xgeometry' do
    it 'formats coordinates and dimensions as X geometry' do
      assert_equal '640x480+0+0', Uh::Geo.format_xgeometry(0, 0, 640, 480)
    end

    it 'formats missing values as ?' do
      assert_equal '?x?+?+?', Uh::Geo.format_xgeometry(*[nil] * 4)
    end
  end

  describe '#to_s' do
    it 'returns .format_xgeometry results' do
      assert_equal Uh::Geo.format_xgeometry(*subject.values), subject.to_s
    end
  end

  %w[width height].each do |dimension|
    describe "##{dimension}=" do
      it 'assigns given value' do
        subject.send "#{dimension}=", 42
        assert_equal 42, subject.send(dimension)
      end

      it 'raises error when 0 is given' do
        assert_raises(Uh::ArgumentError) { subject.send "#{dimension}=", 0 }
      end

      it 'raises error when negative value is given' do
        assert_raises(Uh::ArgumentError) { subject.send "#{dimension}=", -42 }
      end
    end
  end
end
