# /etc/puppet/manifests/site.pp

import "classes/*"

## Base Nodes

node default {
    include sudo
    include sshkeys
    #include access.conf
}

node userprofiles {
    include bash_profile
    include app_profile
}

#node loadbalancer {
#    include nginxlb
#    include monitoring
#}

## Specific Nodes

#node 'fore.ducklington.org' inherits loadbalancer {
#    include django
#    include apacheconf
#    include app
#    include backups
#}
#
#node 'lb1.ducklington.org' inherits loadbalancer {
#}
#
#node 'lollipop.ducklington.org' inherits appserverbasic {
#    include monitoring
#    include backups
#}
#
#node 'test.lollipop.ducklington.org' inherits appserverbasic {
#}
#
#node 'monitoring1.ducklington.org', 'monitoring2.ducklington.org' {
#    include monitoring
#    include monitoringhub
#}