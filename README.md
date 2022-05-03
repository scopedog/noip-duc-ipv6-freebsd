# noip-duc-ipv6-freebsd
Dynamic DNS Client (DUC) for NO-IP + IPv6 + FreeBSD

Install 'curl' if not installed yet.

1. Set your `interface`, `user`, `pass`, `hostname` and `interval` in noip-duc-ipv6.sh.
2. Run # ./install.sh
3. Add noip_duc_ipv6_enable="YES" to /etc/rc.conf
4. Run # service noip_duc_ipv6 start

Note FreeBSD's dns/noip port does not support IPv6.
Somebody please combine IPv4 and 6.
