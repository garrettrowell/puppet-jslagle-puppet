class puppet::config (
  $pluginsync = 'true',
  $report     = 'true',
  $graph      = 'true',
  $graphdir   = '/var/lib/puppet/state/graphs',
  $use_srv    = 'false',
  $srv_domain = undef,
) inherits puppet::params {

  include puppet::configfile
  include stdlib

  validate_string($pluginsync, $report, $graph, $graphdir)

  realize File[$puppet::params::config]

  augeas { 'puppet-agent-config':
    context => "/files${puppet::params::config}",
    changes => [
      "set main/pluginsync ${pluginsync}",
      "set agent/graph ${graph}",
      "set agent/graphdir ${graphdir}",
      "set agent/report ${report}",
    ],
  }

  if $use_srv == 'true' and $srv_domain != undef {
    augeas { 'puppet-agent-srv_records':
      context => "/files${puppet::params::config}",
      changes => [
        'set main/use_srv_records true',
        "set main/srv_domain ${srv_domain}",
      ],
    }
  }

  File[$puppet::params::config] -> Augeas['puppet-agent-config']

}
