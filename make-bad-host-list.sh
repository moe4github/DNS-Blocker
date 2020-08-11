#!/bin/bash

need_update=0

# init/update ad/bad-hosts
bad_hosts="bad-hosts"
if [ -d $bad_hosts ]
then
    cd $bad_hosts
    printf "Update Ad/Bad Hosts ... "
    git remote update &> /dev/null

    git_status=-1
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]
    then
        printf "is already up to date.\n"
    elif [ $LOCAL = $BASE ]
    then
        git merge "$UPSTREAM" &> /dev/null
        printf "done.\n"
        need_update=1
    else
        printf "error!\n"
        echo "check git repo!"
        exit 0
    fi

    cd ..
else
    printf "Init Ad/Bad Hosts ... "
    git clone https://github.com/StevenBlack/hosts $bad_hosts &> /dev/null
    printf "done.\n"
    need_update=1
fi

# init/update trackers
trackers="trackers"
if [ -d $trackers ]
then
    cd $trackers
    printf "Update trackers from duckduckgo/tracker-radar ... "
    git remote update &> /dev/null

    git_status=-1
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]
    then
        printf "is already up to date.\n"
    elif [ $LOCAL = $BASE ]
    then
        git merge "$UPSTREAM" &> /dev/null
        printf "done.\n"
        need_update=1
    else
        printf "error!\n"
        echo "check $trackers git repo!"
        exit 0
    fi

    cd ..
else
    printf "Init trackers from duckduckgo/tracker-radar ... "
    git clone https://github.com/duckduckgo/tracker-radar $trackers &> /dev/null
    printf "done.\n"
    need_update=1
fi

# check before update
if (($need_update == 0))
then
    printf "Nothing to do. Bye\n"
    exit 0
fi

# generate bad_host.list file
# define resulting bad-hosts list file
list="bad_hosts.list"
serial=`date '+%Y%m%d%H'`

# make bind file header
printf "generate fileheader ..."
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
printf "\tdone.\n"

# convert hosts file to bind syntax
printf "add (b)ad hosts ..."
grep -oP '^\d{1,3}\.0\.0\.\d\s+[^\s]+' bad-hosts/hosts | \
sed -r "s/^(.*)\s(.*)$/\2\tA\t\1/g" >> $list
printf "\tdone.\n"

# add trackers to host-list
echo "; begin trackers" >> $list
printf "add trackers ..."
for file in trackers/domains/*.json
do
    domain=$(./tracker.pl --filter=middle --file=$file)
    if ((${#domain} > 0))
    then
        echo "$domain A 0.0.0.0" >> $list
    fi
done
printf "\tdone.\n"

echo "cp bad_host.list file to your bind zone dir."
