class pe_repo::platform::el_4_x86_64(
  $agent_version = $::aio_agent_version,
) {
  notify { 'el-4-x86_64 deprecation warning':
    message  => "el-4-x86_64 has reached end of life and is no longer being maintained. Puppet is no longer supporting or building agents on this platform. Any existing el-4-x86_64 agents you have deployed will continue to work. Please remove this class from classification.",
    loglevel => 'warning',
  }
}
