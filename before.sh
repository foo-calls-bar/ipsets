#!/bin/sh
set -e

ipsets_configured=false
if [ -f '/usr/local/lib/ipsets/ipsets-init.sh' ]; then
  . '/usr/local/lib/ipsets/ipsets-init.sh' \
  && ipsets_configured=true
fi

ip6sets_configured=false
if [ -f '/usr/local/lib/ipsets/ip6sets-init.sh' ]; then
  . '/usr/local/lib/ipsets/ip6sets-init.sh' \
  && ip6sets_configured=true
fi

if [ -f '/etc/default/ufw' ]; then
  . '/etc/default/ufw'
fi

case "$1" in
start)
    $ipsets_configured && restore_ipsets || true
    test $IPV6 = yes || exit 0
    $ip6sets_configured && restore_ip6sets || true
    ;;
stop)
    $ipsets_configured && destroy_ipsets || true
    test $IPV6 = yes || exit 0
    $ip6sets_configured && destroy_ip6sets || true
    ;;
flush-all)
    $ipsets_configured && flush_ipset_chains || true
    test $IPV6 = yes || exit 0
    $ip6sets_configured && destroy_ip6set_chains || true
    ;;
*)
    echo "'$1' not supported"
    echo "Usage: before.init {start|stop|flush-all|status}"
    ;;
esac
