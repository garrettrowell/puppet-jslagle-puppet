class puppet::service (
  $ensure = "running",
  $enabled = "true"
) inherits puppet::params {
  include stdlib

  validate_string($ensure, $enabled)

  service { 'puppet-agent':
    name    => $puppet::params::agentsvc,
    ensure  => $ensure,
    enable => $enabled,
  }

}
