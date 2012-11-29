class puppet::config (
  $pluginsync = "true",
  $report = "true",
  $graph = "true",
  $graphdir = "/var/puppet/state/graphs",
) inherits puppet::params {

  include puppet::configfile
  include stdlib

  validate_string($pluginsync, $report, $graph, $graphdir)

  realize File[$puppet::params::config]

  augeas { 'puppet-agent-config':
    context => "/files${puppet::params::config}",
    changes => [
      "set master/pluginsync ${pluginsync}",
      "set agent/graph ${graph}",
      "set agent/graphdir ${graphdir}",
      "set agent/report ${report}",
    ],
  }

  File[$puppet::params::config] -> Augeas['puppet-agent-config']

}
