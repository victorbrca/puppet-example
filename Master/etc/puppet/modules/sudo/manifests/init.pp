# /etc/puppet/manifests/classes/sudo.pp

# !! Not complete !!


## Option 1 - Downloads the file

class sudo {
    file { "/etc/sudoers":
           owner => "root",
           group => "root",
           mode  => 440,
           source => "puppet://puppetmaster.mydomain.ca/files/sudoers"
    }
}


## Option 2 - Uses augeas
# Allow users belonging wheel group to use sudo - http://xmodulo.com/manage-configurations-linux-puppet-augeas.html

class sudo {
    augeas { 'wheel':
        context => '/files/etc/sudoers', # target file is /etc/sudoers
        changes => [
            # allow wheel users to use sudo
            'set spec[user = "%wheel"]/user %wheel',
            'set spec[user = "%wheel"]/host_group/host ALL',
            'set spec[user = "%wheel"]/host_group/command ALL',
            'set spec[user = "%wheel"]/host_group/command/runas_user ALL',
            'set spec[user = "%wheel"]/host_group/command/tag NOPASSWD: ALL',
        ]
    }
}

augeas { '$user1':
    context => '/files/etc/sudoers', # target file is /etc/sudoers
    changes => [
        # allow wheel users to use sudo
        'set spec[user = "$user1"]/user $user1',
        'set spec[user = "$user1"]/host_group/host ALL',
        'set spec[user = "$user1n"]/host_group/command ALL',
        'set spec[user = "$user1"]/host_group/command/runas_user ALL',
    ]
}


## Option 3 - Uses saz/sudo to download file

# Requires saz/sudo - http://puppetlabs.com/blog/module-of-the-week-sazsudo-manage-sudo-configuration

class sudo {
    sudo::conf {'wheel':
      ensure => 'present',
      content => '%wheel     ALL=(ALL)       NOPASSWD: ALL',
    }
      
    sudo::conf {'$user1':
      ensure => 'present',
      content => ' $user1        ALL=(ALL) ALL',
    }
}