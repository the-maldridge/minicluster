#!/bin/sh

mkdir -p state

export CONSUL_HTTP_ADDR=http://node1:8500
export NOMAD_ADDR=http://node1:4646
export VAULT_ADDR=https://node1.lan:8200

export VAULT_SKIP_VERIFY=true

if [ ! -f state/vault_done ] ; then
    if [ ! -f state/vault_bootstrap.json ] ; then
        while ! vault operator init -format=json -key-shares 1 -key-threshold 1 > state/vault_bootstrap.json ; do
            sleep 5
        done
    fi

    export VAULT_UNSEAL_KEY=$(jq -r .unseal_keys_hex[0] < state/vault_bootstrap.json)
    vault operator unseal $VAULT_UNSEAL_KEY

    export VAULT_TOKEN=$(jq -r .root_token < state/vault_bootstrap.json)
    terraform apply -target=module.vault_base -auto-approve -var nomad_ready=false

    vault kv put resin_internal/nomad/gossip key=$(nomad operator keygen)
    vault kv put resin_internal/consul/gossip key=$(consul keygen)

    # Massive hack alert!  This is bad and should not be done, but it
    # sets up the nomad vault integration by putting the token into
    # the key/value store.
    vault kv put resin_internal/nomad/vault token=$(vault token create -policy resin-nomad-server -period 72h -orphan -format json | jq -r .auth.client_token)

    touch state/vault_done
fi

if [ ! -f state/consul_done ] ; then
    export CONSUL_HTTP_TOKEN=$(vault read -field=token consul/creds/root)
    terraform apply -target=module.consul_base -auto-approve

    export VAULT_TOKEN=$(jq -r .root_token < state/vault_bootstrap.json)

    ctoken=$(consul acl token create -description "Vault Service Token" -policy-name "resin-vault-server" -format json | jq -r .SecretID )
    vault kv put resin_internal/vault/consul_token token=$ctoken
    ctoken=$(consul acl token create -description "Nomad Server Token" -policy-name "resin-nomad-server" -format json | jq -r .SecretID )
    vault kv put resin_internal/nomad/server_consul token=$ctoken
    ctoken=$(consul acl token create -description "Nomad Client Token" -policy-name "resin-nomad-client" -format json | jq -r .SecretID )
    vault kv put resin_internal/nomad/client_consul token=$ctoken

    while vault status ; rc=$? ; [ ! $rc -eq 2 ] ; do
        sleep 2
    done
    vault operator unseal $(jq -r .unseal_keys_b64[0] < state/vault_bootstrap.json)

    touch state/consul_done
fi

if [ ! -f state/nomad_done ] ; then
    while ! curl http://node1.lan:4646/v1/agent/health?type=server ; do
        sleep 2
    done

    terraform apply -target module.vault_base -auto-approve
    export NOMAD_TOKEN=$(vault read -field secret_id nomad/creds/management)
    terraform apply -target=module.nomad_base -auto-approve

    touch state/nomad_done
fi
