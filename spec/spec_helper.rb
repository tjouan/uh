RSpec.configure do |c|
  pid = nil

  c.before(:suite) do
    pid = fork do
      # FIXME: should be removed, or logged in a file
      #STDERR.reopen '/dev/null'
      #exec "Xephyr :42 -ac -br -screen 1024x400"
      exec "Xvfb :42 -ac -br -screen 0 1024x400x24"
    end
    ENV['DISPLAY'] = ':42'
    # FIXME: should select() on server socket?
    # /tmp/.X11-unix/X42
    sleep 0.5
    #Process.detach(pid)
  end

  c.after(:suite) do
    Process.kill 'TERM', pid
    #Process.kill 'KILL', pid
    begin
      Process.wait pid
    rescue Errno::ECHILD
    end
  end
end
