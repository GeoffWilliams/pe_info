class pe_repo::platform::sles_11_s390x(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::sles { 'sles-11-s390x':
    agent_version => $agent_version,
    pe_version => $pe_repo::default_pe_build,
  }
}
