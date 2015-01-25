Troubleshooting
===============

- Ports are open
	- Master - 8140, 443 and possibly 3000
	- Console - 8140, 443
- Masters and agents are on the same version

### Fixing install issues on Puppet Enterprise
- Fix configuration
- Run `puppet-enterprise-uninstaller`
- Run installer again

### Console and Database Troubleshooting

**PostgreSQL is Taking Up Too Much Space**

You may need to enable `Autovacuum=on` to clear old reports/logs for postgreSQL. 

If that's not enough, you can run a rake task (`db:raw:optimize[mode]`) to optimize the db:

```
# cd /opt/puppet/share/puppet-dashboard
# rake db:raw:optimize[reindex|vacuum|reindex+vacuum]
```

**Too Many Background Pending Tasks**

Clear pending tasks/dead workers by restarting the `pe-puppet-dashboard-workers` service

```bash
$ sudo /etc/init.d/pe-puppet-dashboard-workers restart
```

**Cleaning Old Node Reports**

If you wish to delete the oldest reports for performance, storage, or policy reasons, you can use the `reports:prune` rake task.

```bash
sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production reports:prune upto=1 unit=mon
```

*[1] This task can also be scheduled as a cron job*

### Puppet Agent Common Run Errors

- Problems with a node agent key
    - Remove the .pem key from the node in the SSL folder
    - Clean the agent certificate on the master with `puppet cert clean [certname]`
    - Run puppet agent again and sign the agent's cert on the master
- The error "Unable to fetch node definition, but agent run will continue" means that the master is not reachable