# /etc/puppet/manifests/classes/userprofile.pp

    file { "/etc/sudoers":
           owner => "root",
           group => "root",
           mode  => 440,
           source => "puppet://puppetmaster.mydomain.ca/files/sudoers"
    }
}