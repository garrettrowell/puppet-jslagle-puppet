class puppet::master::package (
  $ensure = present
) inherits puppet::params {

  require repos::puppetlabs

  package { 'puppet-master':
    ensure  => $ensure,
    name    => $puppet::params::masterpkg,
    require => Class['repos::puppetlabs'],
  }
}
