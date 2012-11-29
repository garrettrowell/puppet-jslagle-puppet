class puppet::package (
  $ensure = present
) inherits puppet::params {

  require repos::puppetlabs

  package { 'puppet-agent':
    name    => $puppet::params::clientpkg,
    ensure  => $ensure,
    require => Class["repos::puppetlabs"],
  }
}
