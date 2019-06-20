# PE 2019.1 introduces a new way to deprecate (remove) installers
class pe_repo::platform::el_4_i386(
  $agent_version = $::aio_agent_version,
) {
  pe_repo::deprecation_warning { 'el-4-i386':
  }
}
