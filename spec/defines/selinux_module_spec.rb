require 'spec_helper'

# $stdout.puts self.catalogue.to_yaml

describe 'selinux::module', :type => :define do
  let(:title) { 'selinux::module' }

  describe "loading module" do
    modname = 'rsynclocal'
    modules_dir = '/var/lib/puppet/selinux'
    this_module_dir = "#{modules_dir}/#{modname}"
    source = "puppet:///modules/selinux/#{modname}.te"
    let(:title) { modname }
    let(:params) {{
      :source      => source,
      :modules_dir => modules_dir,
    }}
    let(:facts) { {
        :osfamily      => 'RedHat',
        :operatingsystemrelease => '6.4',
    } }

    it { should create_class('selinux') }
    it { should create_class('selinux::params') }
    it { should create_class('selinux::config') }
    it { should create_class('selinux::install') }
    it { should create_package('policycoreutils') }
    it { should create_package('checkpolicy') }
    it { should create_package('selinux-policy') }
    it { should create_package('make') }
    it { should create_selinux__module(modname) }
    it { should create_file("#{this_module_dir}/#{modname}.te")\
      .with(
        'ensure' => 'present',
        'source' => source,
        'tag'    => 'selinux-module'
      ) } 
    it { should create_file("#{this_module_dir}/#{modname}.mod")\
      .with(
        'tag'    => ['selinux-module-build','selinux-module'],
      ) }
    it { should create_file("#{this_module_dir}/#{modname}.pp")\
      .with(
        'tag'    => ['selinux-module-build','selinux-module'],
      ) }
    it { should create_exec("#{modname}-buildmod")\
      .with(
        'command' => "checkmodule -M -m -o #{modname}.mod #{modname}.te",
      ) }
    it { should create_exec("#{modname}-buildpp")\
      .with(
        'command' => "semodule_package -m #{modname}.mod -o #{modname}.pp",
      ) }
    it { should create_exec("#{modname}-install")\
      .with(
        'command' => "semodule -i #{modname}.pp",
      ) }
  end
  [ '4.5', '5.8', '6.4', '7.0', '19' ].each do | osrelease |
    describe "checking package installation: #{osrelease}" do
      modname = 'rsynclocal'
      source = "puppet:///modules/selinux/#{modname}.te"
      modules_dir = '/var/lib/puppet/selinux'
      let(:title) { modname }
      let(:params) {{
        :source      => source,
        :modules_dir => modules_dir,
      }}
      let(:facts) { {
          :osfamily      => 'RedHat',
          :operatingsystemrelease => osrelease,
      } }
      if osrelease.to_f < 7
        it { should create_package('selinux-policy') }
      else
        it { should create_package('selinux-policy-devel') }
      end
    end
  end
end
