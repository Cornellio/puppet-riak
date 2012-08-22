# Class: riak
#
# This module manages puppet-riak
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class riak($package = $riak::params::package) {
  anchor { 'riak::start': } ->
  class { 'riak::package':} ~>
  class { 'riak::config':}  ~>
  class { 'riak::service':} ~>
  anchor { 'riak::end': }
}
