# Set ulimits max open files
#
class riak::tuning::ulimits ($ulimits) {

  $settings = merge($::riak::params::ulimits,$::riak::ulimits)

  $settings.each |String[4,4] $setting, Integer $value| {
    $user = $::riak::user

    notify { 'setting is':
      message => "$setting",
    }

    $user = 'riak'
    $type = $setting
    $key = "$user/$type/$value"

    $path_list  = "domain[.=\"$user\"][./type=\"$type\" and ./item=\"$value\"]"
    $path_match = "domain[.=\"$user\"][./type=\"$type\" and ./item=\"$value\" and ./value=\"$value\"]"

    augeas { "limits_conf/$key":
      # context => $::riak::ulimits_context,
      context => '/files/etc/security/limits.conf',
      onlyif  => "match $path_match size != 1",
      changes => [
        "rm $path_list",
        "set domain[last()+1] $user",
        "set domain[last()]/type $type",
        "set domain[last()]/item $value",
        "set domain[last()]/value $value",
        ],
    }
  }
}
