# DNS-Blocker
Using Bind9 for blacklisting (b)ad hosts and trackers

### Motivation
Prepare a (b)ad host list from [StevenBlack's Project](https://github.com/StevenBlack/hosts) for Linux DNS Server BIND. Also add tracking domains from [DuckDuckGo](https://github.com/duckduckgo/tracker-radar) to this black list.


#### Bind - Response Policy Zone (RPZ) Rewriting
As you can read at the [bind manual (S.91)](https://www.bind9.net/manuals)
>BIND 9 includes a limited mechanism to modify DNS responses for requests analogous to email anti-spam DNS blacklists. Responses can be changed to deny the existence of domains(NXDOMAIN), deny
>the existence of IP addresses for domains (NODATA), or contain other IP addresses or data.

### Install
    git clone https://github.com/moe4github/DNS-Blocker.git

### Config
Add the rpz as new zone in the bind config file __named.conf.local__ (on debian systems)

    zone "rpz" {
        type master;
        file "/etc/bind/<generate rpz filename>";
        allow-query {none;};
        check-names ignore;
    };


The option `check-names ignore;` is used because the generated bad-host list include also host names with underscore. Without this option, bind will not load the file.

After that, add the following option into the __named.conf.options__ config file:

    response-policy { zone "rpz";};

### Update
    git pull <remote repo>
    git pull origin

### Use
    ./make-bad-host-list.sh
After the script execution there will be an additional repository (Steven Blacks Project) in the DNS-Blocker directory.
If everything goes well there will be also the genereted *bad_hosts.list* file.

### Conclusion
Copy or move the *bad_hosts.list* file to the directory you have configured in your `zone "rpz"`

    mv bad_host.list /etc/bind/db.rpz

Thats all!
