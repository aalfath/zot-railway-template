#!/bin/sh
set -eu

: "${ZOT_ADMIN_USER:=admin}"
: "${ZOT_ADMIN_PASSWORD:?set ZOT_ADMIN_PASSWORD}"

# Credentials come from the environment on every start (bcrypt).
htpasswd -Bbn "$ZOT_ADMIN_USER" "$ZOT_ADMIN_PASSWORD" > /etc/zot/htpasswd
if [ -n "${ZOT_EXTRA_USERS:-}" ]; then
  # ZOT_EXTRA_USERS="ci:password1 alice:password2" (read, push and delete; not admin)
  for pair in $ZOT_EXTRA_USERS; do
    htpasswd -Bb /etc/zot/htpasswd "${pair%%:*}" "${pair#*:}" 2>/dev/null
  done
fi

if [ "${ZOT_ANONYMOUS_READ:-false}" = "true" ]; then policy='["read"]'; else policy='[]'; fi
sed -e "s/__ANONYMOUS_POLICY__/$policy/" -e "s/__ADMIN_USER__/$ZOT_ADMIN_USER/" \
  /etc/zot/config.template.json > /etc/zot/config.json

mkdir -p /var/lib/registry
exec zot serve /etc/zot/config.json
