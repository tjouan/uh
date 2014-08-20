require 'spec_helper'

describe Holo::Display do
  describe '.new' do
    context 'without argument' do
      it 'has a nil name attribute' do
        subject.name.should be_nil
      end
    end

    context 'when given a display name as argument' do
      it 'sets name attribute as the display name' do
        described_class.new(':42').name.should == ':42'
      end
    end
  end

  describe '#open' do
    context 'when display exists' do
      subject { described_class.new ENV['DISPLAY'] }

      it 'opens the X11 display' do
        expect { subject.open }.to_not raise_error
      end
    end

    context 'when display does not exist' do
      subject { described_class.new ENV['DISPLAY'] + '1' }

      it 'raises DisplayError' do
        expect { subject.open }.to raise_error(Holo::DisplayError)
      end
    end
  end

  describe '#close' do
    context 'when display is opened' do
      before { subject.open }

      it 'closes the X11 display' do
        expect { subject.close }.to_not raise_error
      end
    end

    context 'when display was not opened' do
      it 'raises DisplayError' do
        expect { subject.close }.to raise_error(Holo::DisplayError)
      end
    end
  end
end
