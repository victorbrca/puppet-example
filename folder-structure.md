# Folder Structure

```
└── etc
    └── puppet
        ├── environments
        │   ├── development
        │   │   ├── development.pp
        │   │   └── environment.conf
        │   ├── null
        │   ├── production
        │   │   ├── environment.conf
        │   │   └── production.pp
        │   └── uat
        │       ├── environment.conf
        │       └── uat.pp
        ├── files
        │   ├── dev
        │   ├── prod
        │   └── uat
        ├── fileserver.conf
        ├── manifests
        │   ├── classes
        │   │   ├── class.md
        │   │   ├── sshkeys.pp
        │   │   ├── sudo.pp
        │   │   ├── userprofile.pp
        │   └── site.pp
        └── puppet.conf
```