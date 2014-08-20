require 'spec_helper'

describe Holo::WM do
  describe '.new' do
    context 'with a block argument' do
      it 'yields given block' do
        expect { |b| described_class.new(&b) }.to yield_with_args
      end
    end

    context 'without block argument' do
      it 'evals given block in the instance context' do
        context = nil
        wm = described_class.new { context = self }
        context.should == wm
      end
    end
  end

  describe '#key' do
    it 'registers a keyboard input event' do
      subject.key(:q) { }
      subject.keys[:q].should be_a Proc
    end
  end

  describe '#clients' do
    it 'registers new client event' do
      subject.client('xterm') { }
      subject.client_rules['xterm'].should be_a Proc
    end
  end
end
