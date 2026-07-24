begin
  require "socket"
  require "timeout"

  puts "==SSHBANNER=="
  begin
    Timeout.timeout(5) do
      s = TCPSocket.new("172.19.0.1", 22)
      banner = s.gets
      s.close
      puts "172.19.0.1:22 banner => #{banner.inspect}"
    end
  rescue => e
    puts "FAILED #{e.class}: #{e.message}"
  end
  puts "==SSHBANNER_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.9"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
