#!/bin/bash
set -eo pipefail
if [[ "$(cat /etc/redhat-release)" = 'Red Hat'* ]]; then
echo -e "\n## This is a RHEL machine ##\n"
cat /etc/redhat-release
#sudo yum -y update && sudo yum -y install policycoreutils-python
sudo yum -y install policycoreutils-python
## system's SELinux configuration: add httpd port 4580 
sudo semanage port -a -t http_port_t -p tcp 4580
fi
