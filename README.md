# DNS-Blocker
Using Bind9 for blacklisting (b)ad hosts

### Motivation
Prepare a (b)ad host list from [StevenBlack's Project] (https://github.com/StevenBlack/hosts) for Linux DNS Server BIND.

#### Bind - Response Policy Zone (RPZ)

### Install and Update
    git clone https://github.com/moe4github/DNS-Blocker.git

### Use
    ./make-bad-host-list.sh

### Conclusion
    mv bad_host.list /etc/bind/db.rpz
