# == Class: riak::params
#
# This class implements the module params pattern, but it's loaded using hiera
# as opposed to the 'default' usage of coding the parameter values in your
# manifest.
#
# == Usage
#
# Don't use this class directly; it's being used where it is needed
#
class riak::params {

  $package = $::operatingsystem ? {
    default           => 'riak'
  }

  $deps = $::operatingssytem ? {
    'centos' => [],
    'redhat' => [],
    default  => ['libc6', 'libssl1.0.0', 'libtinfo5']
  }

  $package_type = $::operatingsystem ? {
    'centos' => 'rpm',
    'redhat' => 'rpm',
    default  => 'deb'
  }

  $package_provider = $::operatingsystem ? {
    'centos' => 'yum',
    'redhat' => 'yum',
    default  => 'dpkg'
  }

  $architecture = $::operatingsystem ? {
    'redhat' => 'el6.x86_64',
    'centos' => 'el6.x86_64',
    default  => 'amd64'
  }

  $version = '1.2.0'

  $error_log = "${log_dir}/error.log"
  $info_log = "${log_dir}/console.log"
  $crash_log = "${log_dir}/crash.log"

  $log_dir = '/var/log/riak'
  $erl_log_dir = '/var/log/riak'
  $data_dir = '/var/lib/riak'
  $lib_dir = '/usr/lib/riak'
  $bin_dir = '/usr/sbin'
  $etc_dir = '/etc/riak'

  $service_autorestart = true
}
