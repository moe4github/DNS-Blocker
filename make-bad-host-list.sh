#!/bin/bash

# update main repro via
#git remote update https://github.com/moe4github/DNS-Blocker

# update init ad/bad-hosts
bad_hosts="bad-hosts"
if [ -d $bad_hosts ]
    then
        cd $bad_hosts
        echo "Update Ad/Bad Hosts ... "
        git remote update https://github.com/StevenBlack/hosts &> /dev/null
        cd ..
    else
        echo "Init Ad/Bad Hosts ... "
        git clone https://github.com/StevenBlack/hosts $bad_hosts &> /dev/null
fi

echo "done"

# define resulting bad-hosts list file
list="bad_hosts.list"
serial=`date '+%Y%m%d%H'`

# make bind file header
cat <<EOT > $list
;
;   bind data file for rpz
;
\$TTL 604800
@       IN  SOA     localhost. root.localhost. (
                     $serial   ; serial
                         604800   ; refresh
                          86400   ; retry
                        2419200   ; expire
                         604800 ) ; negativ cache ttl
;
@               IN  NS  localhost.
;
EOT

# convert hosts file to bind syntax
grep -oP '^\d{1,3}\.0\.0\.\d\s+[^\s]+' bad-hosts/hosts | \
sed -r "s/^(.*)\s(.*)$/\2\tA\t\1/g" >> $list
