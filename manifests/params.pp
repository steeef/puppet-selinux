# Class: selinux::params
#
# Description
#  This class provides default parameters for the selinux class
#
# Sample Usage:
#
# file { "$selinux::params::modules_dir"/foobar.te":
#   ensure => present,
# }
#
class selinux::params (
  $modules_dir = "${::settings::vardir}/selinux"
  ) {
}
