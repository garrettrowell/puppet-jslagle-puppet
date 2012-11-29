#!/usr/bin/env rspec
require 'spec_helper'

describe 'puppet::config' do
  describe 'Basic class setup' do
    it { should contain_class('puppet::params') }
  end

  describe 'Should contain the config file' do
    it {
      should contain_file('/etc/puppet/puppet.conf').with_ensure('present')
    }
  end

  describe 'Default options set in generated config' do
    it { should contain_augeas('puppet-agent-config').with(
      'changes' => [
        "set master/pluginsync true",
        "set agent/graph true",
        "set agent/graphdir /var/puppet/state/graphs",
        "set agent/report true"
    ],
    'context' => "/files/etc/puppet/puppet.conf"
    )}

  end

end
