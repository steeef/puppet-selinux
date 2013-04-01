# == Class: selinux::params
#
#  This class provides default parameters for the selinux class
#
# === Example
#
# file { "$selinux::params::modules_dir"/foobar.te":
#   ensure => present,
# }
#
class selinux::params (
  $modules_dir = "${::settings::vardir}/selinux"
  ) {
}
