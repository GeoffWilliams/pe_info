class pe_repo::platform::el_7_s390x(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::el { 'el-7-s390x':
    agent_version => $agent_version,
    pe_version => $pe_repo::default_pe_build,
  }
}
