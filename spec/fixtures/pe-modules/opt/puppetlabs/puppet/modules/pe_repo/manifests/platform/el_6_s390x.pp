class pe_repo::platform::el_6_s390x(
  $agent_version = $::aio_agent_version,
){
  include pe_repo

  pe_repo::el { 'el-6-s390x':
    agent_version => $agent_version,
    pe_version => $pe_repo::default_pe_build,
  }
}
