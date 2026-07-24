begin
  puts "==JOBJSON=="
  puts `cat "$DEPENDABOT_JOB_PATH" 2>&1`
  puts "==JOBJSON_DONE=="
  puts "==OUTPUTJSON=="
  puts `cat "$DEPENDABOT_OUTPUT_PATH" 2>&1`
  puts "==OUTPUTJSON_DONE=="
  puts "==LSDEPUPDATER=="
  puts `ls -la "$DEPENDABOT_HOME/dependabot-updater/" 2>&1`
  puts `find "$DEPENDABOT_HOME/dependabot-updater" -maxdepth 2 2>&1`
  puts "==LSDEPUPDATER_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.11"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
