require 'spec_helper'

describe Holo::Xlib::Display do
  describe '.new' do
    it { should be }
  end

  describe '#close' do
    it 'closes the X11 display' do
      subject.close
    end
  end

  describe '#root_window' do
    def root_window_id
      `xwininfo -root -int | grep "Window id:"`[/\d+/].to_i
    end

    it 'returns the root window' do
      #p root_window_id
    end
  end
end
