define apache::proxypass ($ensure="present", $location, $url, $vhost) {

  $fname = regsubst($name, "\s", "_", "G")

  if defined(Apache::Module["proxy"]) {} else {
    apache::module {"proxy": }
  }

  if defined(Apache::Module["proxy_http"]) {} else {
    apache::module {"proxy_http": }
  }

  case $operatingsystem {
    redhat,CentOS : {
      $wwwroot = "/var/www/vhosts"
    }
    debian : {
      $wwwroot = "/var/www"
    }
    default : { fail "Unsupported operatingsystem ${operatingsystem}" }
  }

  file{"${wwwroot}/${vhost}/conf/proxypass-${fname}.conf":
    ensure => $ensure,
    content => template("apache/proxypass.erb"),
    seltype => $operatingsystem ? {
      "RedHat" => "httpd_config_t",
      "CentOS" => "httpd_config_t",
      default  => undef,
    },
    notify  => Exec["apache-graceful"],
    require => Apache::Vhost[$vhost],
  }
}
