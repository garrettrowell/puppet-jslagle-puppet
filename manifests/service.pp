class puppet::service (
  $ensure = 'running',
  $enabled = 'true'
) inherits puppet::params {
  include stdlib

  validate_string($ensure, $enabled)

  service { 'puppet-agent':
    ensure  => $ensure,
    name    => $puppet::params::agentsvc,
    enable  => $enabled,
  }

}
