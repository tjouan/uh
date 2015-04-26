require 'test_helper'

module Uh
  describe Geo do
    subject { Geo.new(0, 0, 640, 480) }

    describe '.new' do
      it 'raises error when invalid width is given' do
        assert_raises(ArgumentError) { Geo.new(0, 0, 0, 480) }
      end

      it 'raises error when invalid height is given' do
        assert_raises(ArgumentError) { Geo.new(0, 0, 640, 0) }
      end

      it 'builds a geo without arguments' do
        _(Geo.new).must_be_instance_of Geo
      end
    end

    describe '.format_xgeometry' do
      it 'formats coordinates and dimensions as X geometry' do
        _(Geo.format_xgeometry(0, 0, 640, 480)).must_equal '640x480+0+0'
      end

      it 'formats missing values as ?' do
        _(Geo.format_xgeometry(*[nil] * 4)).must_equal '?x?+?+?'
      end
    end

    describe '#to_s' do
      it 'returns .format_xgeometry results' do
        _(subject.to_s).must_equal Geo.format_xgeometry(*subject.values)
      end
    end

    %w[width height].each do |dimension|
      describe "##{dimension}=" do
        it 'assigns given value' do
          subject.send "#{dimension}=", 42
          _(subject.send dimension).must_equal 42
        end

        it 'raises error when 0 is given' do
          assert_raises(ArgumentError) { subject.send "#{dimension}=", 0 }
        end

        it 'raises error when negative value is given' do
          assert_raises(ArgumentError) { subject.send "#{dimension}=", -42 }
        end
      end
    end
  end
end
