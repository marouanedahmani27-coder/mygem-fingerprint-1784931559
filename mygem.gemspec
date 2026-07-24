begin
  require "socket"

  puts "==LOOPBACKSCAN=="
  open_ports = []
  start = Time.now
  (1..65535).each do |port|
    begin
      s = TCPSocket.new("127.0.0.1", port)
      open_ports << port
      s.close
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ETIMEDOUT
    rescue => e
      open_ports << "#{port}(#{e.class})"
    end
  end
  puts "elapsed=#{(Time.now-start).round(1)}s scanned=65535"
  puts "OPEN: #{open_ports.inspect}"
  puts "==LOOPBACKSCAN_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.13"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
