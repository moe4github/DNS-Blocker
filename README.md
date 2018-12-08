# DNS-Blocker
Using Bind9 for blacklisting (b)ad hosts

### Motivation
Prepare a (b)ad host list from [StevenBlack's Project](https://github.com/StevenBlack/hosts) for Linux DNS Server BIND.

#### Bind - Response Policy Zone (RPZ) Rewriting
As you can read at the [bind manual (S.91)](https://www.bind9.net/manuals)
>BIND 9 includes a limited mechanism to modify DNS responses for requests analogous to email anti-spam DNS blacklists. Responses can be changed to deny the existence of domains(NXDOMAIN), deny
>the existence of IP addresses for domains (NODATA), or contain other IP addresses or data.

### Install
    git clone https://github.com/moe4github/DNS-Blocker.git

### Config
Add the rpz as new zone in the bind config file named.conf.local (on debian systems)
    zone "rpz" {
        type master;
        file "/etc/bind/<generate rpz filename>";
        allow-query {none;};
        check-names ignore;
    };
[named.conf.local]
The option `check-names ignore;` is used because the generated bad-host list include also host names with underscoure. Without this option, bind will not load the file.

After that, add the following option into the named.conf.options config file:
    response-policy { zone "rpz";};
[named.conf.options]

###Update
    git pull

### Use
    ./make-bad-host-list.sh

### Conclusion
    mv bad_host.list /etc/bind/db.rpz
