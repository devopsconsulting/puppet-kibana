# kibana / nginx is a graphical frontend to elasticsearch.
# nginx is installed and a debian package containing the
# webroot.

class kibana::install {
    package { "nginx":
        ensure => present,
    }

    package { "php5-fpm":
        ensure => present,
        require => Package["nginx"],
    }

    package { "kibana.d":
        ensure => latest,
        require => Package["php5-fpm"],
        notify => Class["kibana::config"]
    }
}

class kibana::config {
    file { "/etc/nginx/sites-available/default":
        source => "puppet:///modules/kibana/default",
        group => "root",
        owner => "root",
        mode => "0644",
        ensure => file,
        replace => true,
        require => Class["kibana::install"],
        notify => Class["kibana::service"],
    }
}

class kibana::service { 
    service { "nginx":
        ensure => running,
        enable => true, 
        hasrestart => true,
        require => File["/etc/nginx/sites-available/default"]
    }

    service { "php5-fpm":
        ensure => running,
        enable => true, 
        hasrestart => true,
    }
}

class kibana {
    include kibana::install
    include kibana::config
    include kibana::service
}

