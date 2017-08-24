#!/bin/sh
set -e

SETDIR="/usr/local/lib/ipsets"
CHAINS6="drop6_sets"
IP6SETS="arin6 special6 iana6"

flush_ip6set_chains() {
  local chain ipset
  for chain in $CHAINS6; do
    /sbin/ip6tables -F "$chain" 2>/dev/null || true
  done
  for ipset in $IP6SETS $SETSET; do (
    /sbin/ip6tables -S | grep $ipset | \
      sed '/^-[^A]/d;s/^-A/-D/g' | \
      xargs -I{} /sbin/ip6tables {}
    ) || true
  done
}

destroy_ip6sets() {
  local ipset
  flush_ip6set_chains
  for ipset in $SETSET $IP6SETS; do
    /sbin/ipset destroy $ipset 2>/dev/null || true
  done
  return 0
}

restore_ip6sets() {
  local ipset
  destroy_ip6sets
  for ipset in $IP6SETS $SETSET; do
    /sbin/ipset -f "${SETDIR}/${ipset}.ipset" restore
  done
}
