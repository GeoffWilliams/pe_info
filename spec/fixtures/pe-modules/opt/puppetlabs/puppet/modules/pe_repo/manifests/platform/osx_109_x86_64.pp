class pe_repo::platform::osx_109_x86_64(
  $agent_version = $::aio_agent_build,
) {
  notify { 'osx-10.9-x86_64 deprecation warning':
    message  => "osx-10.9-x86_64 has reached end of life and is no longer being maintained. Puppet is no longer supporting or building agents on this platform. Any existing osx-10.9-x86_64 agents you have deployed will continue to work. Please remove this class from classification.",
    loglevel => 'warning',
  }
}
