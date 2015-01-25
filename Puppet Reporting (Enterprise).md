# Puppet Reporting (Enterprise)

Puppet report is built at the end of every agent run on the node and uploaded to the puppet master and stored in the puppet DB.

The following data is available in the Console dashboard:
- Total - Total number or resources being managed
- Failed - How many resources were no put into desired configuration state
- Changed - Resource was out of sync and puppet changed to desired state
- Unchanged - Resource was in sync
- No-op - Resource was out of sync however puppet was instructed not to change via `noop`
- Skipped - Total number or resources skipped due to tags (or other configuration)
- Failed Restarts - How many resources failed to restart
- Config Retrieval - How long it took for the catalog to be compiled on the master and downloaded to the node
- Runtime - Total time for configuration run

***To check:***
- Scheduled - How many resources are using the scheduling function and ran within the defined period
- Out of sync - How many resources were out of sync or did not match the desired node configuration as defined on the catalog
- Applied - How many resources were put in the desired state
- Restarts - How many resources were restarted

### Enabling Error Reporting

- Regular errors are found in the OS syslog
- To enable the reporting, the node needs to have `report = true` in the `agent` section on `puppet.conf`
- Puppet master specifies how reports are processed. For example, `reports = tagmail, http` in the `master` section of `puppet.conf` will send email and info to the specified http address
- Enabling a report processor also enables an additional parameter for that report. For example, using `report = http` also enables you to specify `reporturl = [url]`

### Report Processors

**Built-in processors**
- console    - Sends it to the puppet enterprise console
- puppetdb   - Sends reports to puppet DB
- http (reporturl)      - Sends reports via http/https
- tagmail    - Sends reports to specified email address
- rrdgraph   - Graphs all data in the RRD library
- log        - Sends all to syslog
- store      - Stores reports in yaml format in the specified location

**Plugin processors**
- IRC
- Twitter
- Jabber
- Hipchat
- Growl
- Campfire
- PagerDuty
- Etc.