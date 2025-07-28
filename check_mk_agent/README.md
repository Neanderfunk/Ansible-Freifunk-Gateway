# check_mk_agent

This role installs a check_mk_agent and some local checks. 

## Requirement

ansible variable **check_mk.deb** must be defined in group_vars or host vars

**check_mk.de** needs to contains the URL to a check-agent.deb

### Example
 
check_mk:
  deb: https://monitoring.ff-comunnity.xy/check_mk/agents/check-mk-agent_<version>_all.deb


# TODO:
* add more local checks
* documentation fo checks
* integrate mrpe.conf to use nrpe checks.