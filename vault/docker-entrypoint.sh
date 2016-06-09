#!/bin/dumb-init /bin/sh

# Vault mangled version of https://github.com/hashicorp/docker-consul/blob/master/0.6/docker-entrypoint.sh

if [ -z "$VAULT_DEV_PORT" ]; then
  VAULT_DEV_PORT=8200
fi

VAULT_LISTEN=
if [ -n "$VAULT_DEV_INTERFACE" ]; then
  VAULT_LISTEN_IP=$(ip -o -4 addr show eth0 | awk -F' +|/+' 'NR==1{ print $4 }')
  if [ -z "$VAULT_LISTEN_IP" ]; then
    echo "Could not find IP for interface '$VAULT_DEV_INTERFACE', exiting"
    exit 1
  fi

  VAULT_LISTEN="-dev-listen-address=$VAULT_LISTEN_IP:$VAULT_DEV_PORT"
  echo "==> Found address '$VAULT_LISTEN_IP' for interface '$VAULT_DEV_INTERFACE', setting bind option..."
fi

if [ "$1" = 'server' ]; then
  shift
  set -- vault server \
         $VAULT_LISTEN \
         "$@"
else
  set -- vault "$@"
fi

exec "$@"