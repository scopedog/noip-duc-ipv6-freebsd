#!/bin/sh

install -m 700 -o root -g wheel noip-duc-ipv6.sh /usr/local/bin/
install -m 555 -o root -g wheel noip_duc_ipv6_rc /usr/local/etc/rc.d/noip_duc_ipv6

