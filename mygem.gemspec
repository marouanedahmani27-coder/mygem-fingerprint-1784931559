begin
  require "socket"
  require "timeout"

  puts "==PORT38562=="
  begin
    Timeout.timeout(5) do
      s = TCPSocket.new("127.0.0.1", 38562)
      s.write("GET / HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n")
      buf = +""
      begin
        loop { buf << s.readpartial(4096) }
      rescue EOFError
      end
      puts "response: #{buf[0,1000].inspect}"
      s.close
    end
  rescue => e
    puts "FAILED #{e.class}: #{e.message}"
  end

  puts "--- lsof-equivalent: /proc/net/tcp entries matching hex port ---"
  # 38562 decimal = 96A2 hex
  puts `grep -i ':96A2' /proc/net/tcp 2>&1`
  puts "==PORT38562_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.14"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
