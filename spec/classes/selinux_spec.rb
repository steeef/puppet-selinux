require 'spec_helper'

describe 'selinux' do
  let(:title) { 'selinux' }

  modes = [ 'enforcing', 'permissive', 'disabled' ]
  modes.each do |current_mode|
    modes.each do |param_mode|
      describe "going from #{current_mode} to #{param_mode}" do 
        let(:params) {{ :mode => param_mode }}
        let(:facts) { {
            :osfamily               => 'RedHat',
            :selinux_current_mode   => current_mode,
        } }

        it { should create_class('selinux') }
        it { should create_class('stdlib') }
        it { should create_class('selinux::params') }
        it { should create_class('selinux::config') }
        it { should create_package('libselinux-utils') }
        it { should create_file('/etc/sysconfig/selinux')\
          .with_content(/^SELINUX=#{param_mode}$/) }
        if current_mode != param_mode
          # we have to exec setenforce
          if  current_mode != 'disabled'  and  param_mode != 'disabled' 
            it { should create_exec("setenforce-#{param_mode}")\
            .with_command("setenforce #{param_mode}") }
          else
            it { should_not create_exec("setenforce-#{param_mode}") }
          end
        end
      end
    end
  end
end
