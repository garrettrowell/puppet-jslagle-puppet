class puppet::master::service (
  $ensure  = 'running',
  $enabled = 'true'
) inherits puppet::params {
  include stdlib

  validate_string($ensure, $enabled)

  service { 'puppet-master':
    ensure => $ensure,
    name   => $puppet::params::mastersvc,
    enable => $enabled,
  }

}
