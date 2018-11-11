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
