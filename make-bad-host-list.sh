#!/bin/bash

#
# init/update ad/bad-hosts
#

bad_hosts="bad-hosts"
if [ -d $bad_hosts ]
    then
        cd $bad_hosts
        printf "Update Ad/Bad Hosts ... "

        # exist update from master branch?
        git pull | grep -qi 'master'
        if [ $? -gt 0 ]
            then
                printf "\tNothing to do!\n"
                exit 0
        fi
        cd ..
    else
        printf "Init Ad/Bad Hosts ... "
        git clone https://github.com/StevenBlack/hosts $bad_hosts &> /dev/null
fi

printf "\tdone.\n"

#
# generate bad_host.list file
#

printf "generate bad_host.list ..."
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

printf "\tdone.\n"
echo "cp bad_host.list file to your bind zone dir."
