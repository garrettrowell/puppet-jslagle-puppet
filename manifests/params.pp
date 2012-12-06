class puppet::params {
  case $::osfamily {
    Redhat: {
      $masterpkg = "puppetmaster"
      $agentpkg = "puppet"
      $agentsvc = "puppet"
    }

    Debian: {
      $masterpkg = "puppetmaster"
      $agentpkg = "puppet"
      $agentsvc = "puppet"
    }

    default: {
      err("OS Family ${::osfamily} not supported")
    }
  }

  # Packages are more likely to change, so we'll leave them in the
  # case - the config files are pretty consistent
  $config = "/etc/puppet/puppet.conf"
 
}
