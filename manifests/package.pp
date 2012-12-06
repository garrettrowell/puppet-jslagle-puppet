class puppet::package (
  $ensure = present
) inherits puppet::params {

  require repos::puppetlabs

  package { 'puppet-agent':
    ensure  => $ensure,
    name    => $puppet::params::agentpkg,
    require => Class['repos::puppetlabs'],
  }
}
