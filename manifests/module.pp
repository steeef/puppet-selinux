# == Define: selinux::module
#
#  This define will either install or uninstall a SELinux module from a running
#  system. This module allows an admin to keep .te files in text form in a
#  repository, while allowing the system to compile and manage SELinux modules.
#
# === Parameters
#
#   [*ensure*]
#     (present|absent) - sets the state for a module
#
#   [*modules_dir*]
#      The directory compiled modules will live on a system. Defaults to
#      /usr/share/selinux declared in $selinux::params
#
#   [*source*]
#     Source file (either a puppet URI or local file) of the SELinux .te module
#
# ===  Example
#
#    selinux::module { 'rsynclocal':
#      source => 'puppet:///modules/selinux/rsynclocal.te',
#    }
#
define selinux::module(
  $source,
  $ensure  = 'present',
  $modules_dir = undef,
) {
  include selinux
  include selinux::install
  if $modules_dir {
    $selinux_modules_dir = $modules_dir
  } else {
    $selinux_modules_dir = $selinux::params::modules_dir
  }
  $this_module_dir = "${selinux_modules_dir}/${name}"

  # Set Resource Defaults
  File {
    owner => 'root',
    group => 'root',
    mode  => '0640',
  }

  # Only allow refresh in the event that the initial .te file is updated.
  Exec {
    path        => '/sbin:/usr/sbin:/bin:/usr/bin',
    refreshonly => true,
    cwd         => $this_module_dir,
  }

  $active_modules = '/etc/selinux/targeted/modules/active/modules'
  # Specific executables based on present or absent.
  case $ensure {
    present: {
      ## Begin Configuration
      file { $this_module_dir:
        ensure => directory,
      }
      file { "${this_module_dir}/${name}.te":
        ensure  => $ensure,
        source  => $source,
        tag     => 'selinux-module',
        require => File[$this_module_dir],
      }
      file { "${this_module_dir}/${name}.mod":
        tag => ['selinux-module-build', 'selinux-module'],
      }
      file { "${this_module_dir}/${name}.pp":
        tag => ['selinux-module-build', 'selinux-module'],
      }

      exec { "${name}-buildmod":
        command => "checkmodule -M -m -o ${name}.mod ${name}.te",
      }
      exec { "${name}-buildpp":
        command => "semodule_package -m ${name}.mod -o ${name}.pp",
      }
      exec { "${name}-install":
        command => "semodule -i ${name}.pp",
      }

      # Set dependency ordering
      File["${this_module_dir}/${name}.te"]
      ~> Exec["${name}-buildmod"]
      ~> Exec["${name}-buildpp"]
      ~> Exec["${name}-install"]
      -> File<| tag == 'selinux-module-build' |>
    }
    disable: {
      exec { "${name}-disable":
        command => "semodule -d ${name}",
      }
    }
    absent: {
      exec { "${name}-remove":
        command => "semodule -r ${name} > /dev/null 2>&1",
        unless  => "! not -f ${active_modules}/${name}"
      }
    }
    default: {
      fail("Invalid status for SELinux Module: ${ensure}")
    }
  }
}
