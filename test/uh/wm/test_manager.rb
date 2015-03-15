require 'test_helper'
require 'uh/wm'

module Uh
  class WM
    describe Manager do
      let(:output)  { StringIO.new }
      let(:window)  { Minitest::Mock.new }
      subject       { Manager.new }

      it 'has no clients' do
        assert subject.clients.empty?
      end

      describe '#configure' do
        context 'with new window' do
          it 'sends a default configure event to the window' do
            window.expect :configure_event, window, [Geo.new(0, 0, 320, 240)]
            subject.configure window
            window.verify
          end

          context 'with a registered callback' do
            it 'sends configure event with geo returned by callback' do
              subject.on_configure { Geo.new(0, 0, 42, 42) }
              window.expect :configure_event, window, [Geo.new(0, 0, 42, 42)]
              subject.configure window
              window.verify
            end
          end
        end

        context 'with known window' do
          let(:client) { Minitest::Mock.new }

          before do
            subject.clients << client
            client.expect :window, window
          end

          it 'sends a configure message to the client for given window' do
            window.expect :==, true, [Object]
            client.expect :configure, client
            subject.configure window
            client.verify
          end
        end
      end

      describe '#map' do
        before do
          window.expect :override_redirect?, false
        end

        it 'registers a new client' do
          subject.map window
          assert_equal 1, subject.clients.size
        end

        it 'calls the manage callback' do
          subject.on_manage do |client|
            assert_equal subject.clients[0], client
            throw :manage
          end
          assert_throws(:manage) { subject.map window }
        end
      end

      describe '#unmap' do
        let(:client) { Client.new(window) }

        before do
          subject.clients << client
          window.expect :==, true, [Object]
        end

        context 'when client unmap count is 0 or less' do
          it 'preserves the unmap count' do
            subject.unmap window
            assert_equal 0, client.unmap_count
          end

          it 'unmanages the client' do
            subject.unmap window
            refute_includes subject.clients, client
          end

          it 'calls the unmanage callback' do
            subject.on_unmanage do |c|
              assert_equal client, c
              throw :unmanage
            end
            assert_throws(:unmanage) { subject.unmap window }
          end
        end

        context 'when client unmap count is strictly positive' do
          before { client.unmap_count += 1 }

          it 'decrements the unmap count' do
            subject.unmap window
            assert_equal 0, client.unmap_count
          end

          it 'does not unmanage the client' do
            subject.unmap window
            assert_includes subject.clients, client
          end
        end
      end

      describe '#destroy' do
        let(:client) { Client.new(window) }

        before do
          subject.clients << client
          window.expect :==, true, [Object]
        end

        it 'unmanages the client' do
          subject.destroy window
          refute_includes subject.clients, client
        end

        it 'calls the unmanage callback' do
          subject.on_unmanage do |c|
            assert_equal client, c
            throw :unmanage
          end
          assert_throws(:unmanage) { subject.destroy window }
        end
      end

      describe '#update_properties' do
        context 'with known window' do
          before do
            window.expect :==, true, [Object]
            window.expect :name, 'window'
            window.expect :wclass, 'window class'
          end

          it 'updates client window properties' do
            client = Minitest::Mock.new
            client.expect :window, window
            subject.clients << client
            client.expect :update_window_properties, client
            subject.update_properties window
            client.verify
          end

          it 'calls the change callback' do
            client = Client.new(window)
            subject.clients << client
            subject.on_change do |c|
              assert_same client, c
              throw :change
            end
            assert_throws(:change) { subject.update_properties window }
          end
        end
      end
    end
  end
end
