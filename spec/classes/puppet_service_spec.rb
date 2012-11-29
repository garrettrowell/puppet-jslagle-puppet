#!/usr/bin/env rspec
require 'spec_helper'

describe 'puppet::service' do

   let(:facts) { { :osfamily => 'RedHat' } }
  describe 'Basic class setup' do
    it { should contain_class('puppet::params') }
  end

  describe 'Service should be enabled and running' do
    it { should contain_service('puppet-agent').with(
      'name' => 'puppet',
      'ensure' => 'running',
      'enable' => 'true'
      )
    }
  end

end
