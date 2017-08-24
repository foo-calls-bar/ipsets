#!/bin/sh
set -e

SETDIR="/usr/local/lib/ipsets"
CHAINS="drop_sets"
IPSETS="special arin"

flush_ipset_chains() {
  local chain ipset
  for chain in $CHAINS; do
    /sbin/iptables -F "$chain" 2>/dev/null || true
  done
  for ipset in $IPSETS $SETSET; do (
    /sbin/iptables -S | grep $ipset | \
      sed '/^-[^A]/d;s/^-A/-D/g' | \
      xargs -I{} /sbin/iptables {}
    ) || true
  done
}

destroy_ipsets() {
  local ipset
  flush_ipset_chains
  for ipset in $SETSET $IPSETS; do
    /sbin/ipset destroy $ipset 2>/dev/null || true
  done
  return 0
}

restore_ipsets() {
  local ipset
  destroy_ipsets
  for ipset in $IPSETS $SETSET; do
    /sbin/ipset -f "${SETDIR}/${ipset}.ipset" restore
  done
}
