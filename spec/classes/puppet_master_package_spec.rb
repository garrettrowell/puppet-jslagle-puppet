#!/usr/bin/env rspec
require 'spec_helper'

describe 'puppet::master::package' do
  describe 'Basic class setup' do
    it { should contain_class('puppet::params') }
  end
  describe 'test RedHat functions' do

    let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '6.2',
      :hardwareisa => 'x86_64' }}

    describe 'RedHat should get puppet package' do
      it { should contain_package('puppet-master').with_name('puppetmaster') }
    end
  end

  describe 'test Debian related' do
    let(:facts) { { :osfamily => 'Debian', :operatingsystemrelease => '12.10',
      :hardwareisa => 'x86_64', :lsbdistcodename => 'quantal' }}

    describe 'Install debian package' do
      it { should contain_package('puppet-master').with_name('puppetmaster') }
    end
  end
end
