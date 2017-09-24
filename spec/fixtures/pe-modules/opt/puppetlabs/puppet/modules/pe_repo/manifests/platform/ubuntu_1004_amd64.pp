class pe_repo::platform::ubuntu_1004_amd64(
  $agent_version = $::aio_agent_version,
) {
  notify { 'ubuntu-10.04-amd64 deprecation warning':
    message  => "ubuntu-10.04-amd64 has reached end of life and is no longer being maintained. Puppet is no longer supporting or building agents on this platform. Any existing ubuntu-10.04-amd64 agents you have deployed will continue to work. Please remove this class from classification.",
    loglevel => 'warning',
  }
}
