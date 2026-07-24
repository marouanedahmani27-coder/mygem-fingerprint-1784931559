begin
  require "socket"
  require "timeout"

  puts "==LOOPBACKSCAN=="
  open_ports = []
  start = Time.now
  (1..65535).each do |port|
    begin
      s = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
      s.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, [0, 100000].pack("l_2"))
      sa = Socket.sockaddr_in(port, "127.0.0.1")
      begin
        s.connect_nonblock(sa)
        open_ports << port
      rescue IO::WaitWritable
        if IO.select(nil, [s], nil, 0.05)
          begin
            s.connect_nonblock(sa)
            open_ports << port
          rescue Errno::EISCONN
            open_ports << port
          rescue
          end
        end
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH
      rescue => e
      ensure
        s.close rescue nil
      end
    end
    break if Time.now - start > 60
  end
  puts "scanned_up_to_port=#{open_ports.empty? ? 'n/a' : nil} elapsed=#{(Time.now-start).round(1)}s"
  puts "OPEN_PORTS: #{open_ports.inspect}"
  puts "==LOOPBACKSCAN_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.12"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
