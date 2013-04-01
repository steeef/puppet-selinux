# SELinux Puppet Module

This module can set SELinux and deploy SELinux type enforcement files (.te)
modules to running RHEL based system. Forked from jfryman, we added:
- all enforcing/permissive/disabled switch covered
- ability to select selinux module directory
- many bug fixes
- puppet lint compliant code
- full spec testing

# Requirements
- puppetlabs/stdlib >= 3.0.0
- RedHat/Fedora based distribution

# Installation
<pre>
puppet module install spiette/selinux
</pre>

# Synopsys
<pre>
include selinux
selinux::module { 'rsynclocal':
    source => 'puppet:///modules/site/rsynclocal.te'
}
</pre>

<pre>
class { 'selinux':
  mode => 'permissive'
}
</pre>

<pre>
selinux::module { 'rsynclocal':
  ensure => 'disabled'
}
</pre>

<pre>
selinux::module { 'rsynclocal':
  ensure => 'absent'
}
</pre>

# Contribute

Please see the [Github](https://github.com/spiette/puppet-selinux) page. We'll review  pull requests and bug reports. If the module don't do what you want, please explain your use case. Testing on Debian-based distributions is welcome.

# Credits
- Maintainer: Simon Piette <piette.simon@gmail.com>
- Original module from James Fryman <james@frymanet.com> https://github.com/jfryman/puppet-selinux
- selinux::booleans is a contribution from GreenOgre <aggibson@cogeco.ca> 
- Concepts incorporated from:
http://stuckinadoloop.wordpress.com/2011/06/15/puppet-managed-deployment-of-selinux-modules/
