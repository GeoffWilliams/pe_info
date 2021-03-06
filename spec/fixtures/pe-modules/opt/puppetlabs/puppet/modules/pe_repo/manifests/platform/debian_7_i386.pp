class pe_repo::platform::debian_7_i386(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::debian { 'debian-7-i386':
    agent_version => $agent_version,
    codename   => 'wheezy',
    pe_version => $pe_repo::default_pe_build,
  }
}
