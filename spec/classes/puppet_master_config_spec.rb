#!/usr/bin/env rspec
require 'spec_helper'

describe 'puppet::master::config' do
  let (:params) {{ :puppetdb_server => "localhost", :puppetdb_port => "8080" }}
  describe 'Basic class setup' do
    it { should contain_class('puppet::params') }
  end

  describe 'Should contain the config file' do
    it {
      should contain_file('/etc/puppet/puppet.conf').with_ensure('present')
    }
  end

  describe 'Default options set in generated config' do
    it { should contain_augeas('puppet-master-config').with(
      'changes' => [
        "set master/reports store",
        "set master/storeconfigs true",
        "set master/storeconfigs_backend puppetdb"
    ],
    'context' => "/files/etc/puppet/puppet.conf"
    )}

  end

  describe 'Files needed by master' do
    it { should contain_file('/etc/puppet/auth.conf').with(
      'ensure' => 'present',
      'owner'  => 'root',
      'mode'   => '0644',
      'source' => 'puppet:///modules/puppet/etc/puppet/auth.conf'
    )}
    it { should contain_file('/etc/puppet/fileserver.conf').with(
      'ensure' => 'present',
      'owner'  => 'root',
      'mode'   => '0644',
      'source' => 'puppet:///modules/puppet/etc/puppet/fileserver.conf'
    )}
  end

  describe 'Default config contains puppetdb - test for resources' do
    it { should contain_file('/etc/puppet/routes.yaml').with(
      'ensure' => 'present',
      'owner'  => 'root',
      'mode'   => '0644',
      'source' => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
    )}
    it { should contain_file('/etc/puppet/puppetdb.conf').with(
      'ensure' => 'present',
      'owner'  => 'root',
      'mode'   => '0644',
      'content' => /localhost/
    )}
  end

  describe 'Check for error if puppetdb true and no server' do
    let (:params) {{ :puppetdb => "true" }}
    it do
      expect {
        should contain_file('/etc/puppet/puppetdb.conf')
      }.to raise_error(Puppet::Error,/server and port/)
    end
  end

end
