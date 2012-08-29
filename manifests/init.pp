# Class: riak
#
# This module manages Riak, the dynamo-based NoSQL database.
#
# == Parameters
#
# version:
#   Version of package to fetch
#
# package:
#   Name of package as known by OS
#
# package_hash:
#   A URL of a hash-file or sha2-string in hexdigest
#
# source:
#   Sets the content of source parameter for main configuration file
#   If defined, riak's app.config file will have the param: source => $source.
#   Mutually exclusive with $template.
#
# template:
#   Sets the content of the content parameter for the main configuration file
#
# architecture:
#   What architecture to fetch/run on
#
#
# == Actions
#
# == Requires
#
# * stdlib (module)
#
# == Usage
#
# class { 'riak': }
#
# == Author
#   Henrik Feldt, github.com/haf/puppet-riak.
#
# == Notes
#
#  Uses hiera:
#   * https://github.com/puppetlabs/hiera-puppet <- required module
#   * https://github.com/gposton/vagrant-hiera <- for vagrant testing
#   * https://github.com/amfranz/rspec-hiera-puppet <- for rspec testing
#   * https://github.com/puppetlabs/hiera <- actual hiera DB
#
class riak(
  $version = hiera('version'),
  $package = hiera('package'),
  $package_hash = hiera('package_hash', ''),
  $source = hiera('source', ''),
  $template = hiera('template'),
  $architecture = hiera('architecture'),
  $log_dir = hiera('log_dir'),
  $erl_log_dir = hiera('erl_log_dir'),
  $service_autorestart = hiera('service_autorestart', 'true'),
  $disable = false,
  $disableboot = false,
  $absent = false
) {

  include stdlib

  $download_os = $::operatingsystem ? {
    /(centos|redhat)/ => 'rhel/6',
    'ubuntu'          => 'ubuntu/precise',
    'debian'          => 'ubuntu/precise',
    default           => 'ubuntu/precise'
  }

  $download_base = "http://downloads.basho.com.s3-website-us-east-1.amazonaws\
.com/riak/CURRENT/${download_os}"

  $url_source = "${$download_base}/riak_${$version}-1_\
${$riak::params::architecture}.${$riak::params::package_type}"

  $url_source_hash = "${$url_source}.sha"

  $actual_hash = $package_hash ? {
    undef   => $url_source_hash,
    ''      => $url_source_hash,
    default => $package_hash
  }

  $pkgfile = "/tmp/${$package}-${$version}.${$riak::params::package_type}"

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  $manage_package = $absent ? {
    true => 'absent',
    default => 'latest',
  }

  $manage_service_ensure = $disable ? {
    true => 'stopped',
    default => $absent ? {
      true => 'stopped',
      default => 'running',
    },
  }

  $manage_service_enable = $disableboot ? {
    true => false,
    default => $disable ? {
      true => false,
      default => $absent ? {
        true => false,
        default => true,
      },
    },
  }

  $manage_file = $absent ? {
    true    => 'absent',
    default => 'present'
  }

  $manage_service_autorestart = $service_autorestart ? {
    /true/ => 'Service[riak]',
    default => undef,
  }

  anchor { 'riak::start': }  ->

  httpfile {  $pkgfile:
    ensure => present,
    source => $url_source,
    hash   => $actual_hash
  }

  package { 'riak':
    ensure  => $manage_package,
    provider=> dpkg,
    source  => $pkgfile,
    require => Httpfile[$pkgfile],
  }

  file { '/etc/riak/app.config':
    ensure  => $manage_file,
    # todo: support source
    content => template($template),
    notify  => $manage_service_autorestart
  }

  class { 'riak::vmargs':
    absent => $absent,
    notify => $manage_service_autorestart,
  }

  service { 'riak':
    ensure  => $manage_service_ensure,
    enable  => $manage_service_enable,
    require => [
      File['/etc/riak/vm.args'],
      File['/etc/riak/app.config'],
      Package['riak']
    ],
  } ~>

  anchor { 'riak::end': }
}
