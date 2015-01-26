Puppet Enterprise Console
=========================

The console is a management interface for Puppet Enterprise. It allows you to:
- Manage node requests (sign certs)
- Assign classes to nodes and groups
- View reports and activity graphs
- Manually trigger puppet runs
- View and compare resource data on nodes
- Invoke orchestration actions on your nodes (orchestration engine)
- Manage console users
- Works separate than the puppet enterprise core

***Note:*** A variable defined in the console is a top scope variable (same as a variable defined in site.pp outside a node definition)

### Live Management

Live management is an interface to the orchestration engine. It can be used to browse resources on nodes and invoke actions.

##### Enabling/Disabling

To disable live management, add the following line to `/etc/puppetlabs/puppet-dashboard/settings.yml` and restart `pe-httpd`:

```
disable_live_management = true
/etc/init.d/pe-httpd restart
```

##### Filtering Nodes

Nodes can be filtered:
- Node filter - Filters the node by name
- Class (Advanced search)
- Fact (Advanced search) - Requires fact name and fact value


### Event Inspector

Puppet Enterprise (PE) event inspector is a reporting tool that provides data for investigating the current state of your infrastructure.

It lets you accomplish two important tasks: monitoring a summary of your infrastructure’s activity and analyzing the details of important changes and failures.


*[1] An event is puppet's attempt to modify an individual property of a given resource.*

*[2] The displayed data does not refresh automaticaly (on purpose). You need to refresh the page.*