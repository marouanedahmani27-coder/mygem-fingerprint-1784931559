begin
  puts "==CACHEPOISON2=="
  puts "--- look for marker from a PREVIOUS, SEPARATE job ---"
  puts `cat /opt/bundler/v2/.bundle/CROSSJOB_MARKER_a8f3e2 2>&1`
  puts "current job id: #{ENV['DEPENDABOT_JOB_ID']}"
  puts "==CACHEPOISON2_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.17"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
