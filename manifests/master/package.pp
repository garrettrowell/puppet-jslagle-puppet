class puppet::master::package (
  $ensure = present
) inherits puppet::params {

  require repos::puppetlabs

  package { 'puppet-master':
    name    => $puppet::params::masterpkg,
    ensure  => $ensure,
    require => Class["repos::puppetlabs"],
  }
}
