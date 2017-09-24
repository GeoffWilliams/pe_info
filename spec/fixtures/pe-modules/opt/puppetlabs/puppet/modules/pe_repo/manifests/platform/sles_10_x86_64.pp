class pe_repo::platform::sles_10_x86_64(
  $agent_version = $::aio_agent_version,
) {
  notify { 'sles-10-x86_64 deprecation warning':
    message  => "sles-10-x86_64 has reached end of life and is no longer being maintained. Puppet is no longer supporting or building agents on this platform. Any existing sles-10-x86_64 agents you have deployed will continue to work. Please remove this class from classification.",
    loglevel => 'warning',
  }
}
