# Folder Structure

```bash
└── etc
    └── puppet
        ├── environments
        │   ├── development
        │   │   ├── development.pp
        │   │   └── environment.conf
        │   ├── null
        │   ├── production
        │   │   ├── environment.conf
        │   │   └── production.pp
        │   └── uat
        │       ├── environment.conf
        │       └── uat.pp
        ├── files
        │   ├── dev
        │   ├── prod
        │   └── uat
        ├── fileserver.conf
        ├── manifests
        │   ├── classes
        │   │   ├── class.md
        │   │   ├── sshkeys.pp
        │   │   ├── sudo.pp
        │   │   ├── userprofile.pp
        │   └── site.pp
        └── puppet.conf
```

```bash
#/etc/puppet
.
├── manifests
│   └── site.pp
├── modules
│   ├── base
│   │   ├── files
│   │   │   └── sshd_config
│   │   ├── manifests
│   │   │   ├── init.pp
│   │   │   ├── params.pp
│   │   │   ├── ssh.pp
│   │   └── tests
│   │       ├── init.pp
│   │       └── ssh.pp
│   ├── localusers
│   │   ├── files
│   │   ├── manifests
│   │   │   ├── groups
│   │   │   │   ├── finance.pp
│   │   │   │   └── wheel.pp
│   │   │   └── init.pp
│   │   ├── templates
│   │   └── tests
│   │       └── init.pp
│   └── motd
│       ├── files
│       │   └── motd
│       ├── manifests
│       │   └── init.pp
│       ├── templates
│       └── tests
│           └── init.pp
├── puppet.conf
```