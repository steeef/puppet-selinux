require 'spec_helper'

describe 'selinux' do
  let(:title) { 'selinux' }

  #  osfamily, operatingsystemrelease, param
  testmatrix = [
      [ 'RedHat', 5, nil ],
      [ 'RedHat', 5, 'enforcing' ],
      [ 'RedHat', 6, nil ],
      [ 'RedHat', 6, 'enforcing' ],
      [ 'RedHat', 7, 'enforcing' ],
  ]
  testmatrix.each do |os, osrelease, mode|
    case os
    when 'RedHat', 'CentOS', 'Scientific', 'Fedora'
      osfamily = 'RedHat'
      if osrelease <= 5
          followsymlinks = ''
      else
          followsymlinks = 'follow-symlinks'
      end
      if osrelease > 7
        selinuxfs = '/sys/fs/selinux'
      else
        selinuxfs = '/selinux'
      end
    when 'Fedora'
      osfamily = 'RedHat'
      selinuxfs = '/sys/fs/selinux'
    when 'Debian', 'Ubuntu'
      osfamily = 'Debian'
      selinuxfs = '/sys/fs/selinux'
    end
    
    describe "class, mode: #{mode} param on #{os} #{osrelease}" do 
      if mode == nil
        let(:params) {{ }}
        created_mode = 'permissive'
      else
        let(:params) {{ :mode => mode }}
        created_mode = mode
      end
      let(:facts) { {
          :osfamily               => osfamily,
          :operatingsystem        => os,
          :operatingsystemrelease => osrelease,
      } }

      case created_mode
      when 'enforcing'
          sestatus = 1
      when 'permissive'
          sestatus = 0
      when 'disabled'
          sestatus = 0
      end

      it { should create_class('selinux') }
      it { should create_class('stdlib') }
      it { should create_class('selinux::config') }
      #it { should create_package('selinux') }
      # /selinux/enforce
      it { should create_exec("change-selinux-status-to-#{created_mode}") }
      it { should create_exec("change-selinux-status-to-#{created_mode}")\
          .with_command(/echo #{sestatus} > #{selinuxfs}/) }
      it { should create_exec("set-selinux-config-to-#{created_mode}") }
      it { should create_exec("set-selinux-config-to-#{created_mode}")\
          .with_command(/sed.*#{followsymlinks}.*\/etc\/sysconfig\/selinux/) }
    end
  end
end
