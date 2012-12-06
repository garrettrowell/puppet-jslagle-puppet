class puppet::package (
  $ensure = present
) inherits puppet::params {

  require repos::puppetlabs

  package { 'puppet-agent':
    name    => $puppet::params::agentpkg,
    ensure  => $ensure,
    require => Class["repos::puppetlabs"],
  }
}
