# noip-duc-ipv6-freebsd
Dynamic DNS Client (DUC) for NO-IP + IPv6 + FreeBSD

1. Set your `interface`, `user`, `pass`, `hostname` and `interval` values in no
ip-duc-ipv6.sh.
2. Run # install.sh
3. Add noip_duc_ipv6_enable="YES" to /etc/rc.conf
4. Run # service noip_duc_ipv6 start
