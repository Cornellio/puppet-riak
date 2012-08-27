# Class: riak::package
#
# Handles the Riak package; its downloading and installation/removal.
#
# Parameters:
#
#
#
# Actions: none
#
# Requires: none
#
# Sample Usage: none
class riak::package(
  $version = $riak::params::version,
  $package = $riak::params::package,
  $hash = undef
) inherits riak::params {
  $download_base = "http://downloads.basho.com.s3-website-us-east-1.amazonaws\
.com/riak/CURRENT/${$riak::params::download_os}"

  $url_source = "${$download_base}/riak_${$version}-1_\
${$riak::params::architecture}.${$riak::params::package_type}"

  $url_source_hash = "${$url_source}.sha"

  $actual_hash = $hash ? {
    undef   => $url_source_hash,
    ''      => $url_source_hash,
    default => $hash
  }

  $pkgfile = "/tmp/${$package}-${$version}.${$riak::params::package_type}"

  httpfile {  $pkgfile:
    ensure => present,
    source => $url_source,
    hash   => $actual_hash
  }

  package { $package:
    ensure  => latest,
    require => Httpfile["/tmp/riak-${$version}.${$riak::params::package_type}"],
    provider=> dpkg,
    source  => $pkgfile
  }
}