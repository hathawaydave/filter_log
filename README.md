# filter_log
This is a perl script that decodes much of the pfSense filterlog.log... the firewall log.  It is based on the official [Raw Filter Log Format](https://docs.netgate.com/pfsense/en/latest/monitoring/logs/raw-filter-format.html) from Netgate (accessed 2021-12-21).

This script reads from STDIN and outputs to STDOUT.  I cat the log into the script and then use less or grep to affect the output:

```
cat /var/log/pfsense/filterlog.log | filter-log.pl | grep 69.27.252.140
```
(Note that I use remote logging to copy the log from the BSD-based pfSense box to an Ubuntu server.)

Because I use the fish shell, I mainly use a function:
```
function filter_log --description "Pretty Print pfsense filterlog.log"
  tail -n 1000 /var/log/pfsense/filterlog.log | filter-log.pl
end
```