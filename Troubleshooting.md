# Troubleshooting


- Ports are open (3000, 8140, 443)
- Masters and agents are on the same version


### Fixing install issues on Puppet Enterprise
- Fix configuration
- Run `puppet-enterprise-installer`
- Run installer again

### Rake

- `Reports:prune` (rake task) - Clean out old reports
- Optimize dashboard database by running `db:raw:optimize`
    - Advised to be done monthly
    - Needs to be added to cron

### Console and Database Troubleshooting

- Clear pending tasks/dead workers by restarting the `pe-puppet-dashboard-workers` service
- May need to enable `Autovacuum=on` to clear old reports/logs for postgreSQL

### Puppet Agent Run Errors

- Problems with a node agent key
    - Remove the .pem key from the node in the SSL folder
    - Clean the agent certificate on the master with `puppet cert clean [certname]`
    - Run puppet agent again and sign the agent's cert on the master
- The error "Unable to fetch node definition, but agent run will continue" means that the master is not reachable