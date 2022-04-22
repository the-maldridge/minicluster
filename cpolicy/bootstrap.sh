#!/bin/sh

mkdir -p state

export CONSUL_HTTP_ADDR=http://node1:8500
export NOMAD_ADDR=http://node1:4646
export VAULT_ADDR=https://node1.lan:8200

export VAULT_SKIP_VERIFY=true

if [ ! -f state/vault_done ] ; then
    if [ ! -f state/vault_bootstrap.json ] ; then
        while ! vault operator init -format=json -n 1 -t 1 > state/vault_bootstrap.json ; do
            sleep 5
        done
    fi

    export VAULT_UNSEAL_KEY=$(jq -r .unseal_keys_hex[0] < state/vault_bootstrap.json)
    vault operator unseal $VAULT_UNSEAL_KEY

    export VAULT_TOKEN=$(jq -r .root_token < state/vault_bootstrap.json)
    terraform apply -target=module.vault_base -auto-approve

    vault token create -policy resin-nomad-server \
          -period 72h -orphan \
          -format json > state/vault_nomad_token.json

    jq -r .auth.client_token < state/vault_nomad_token.json > secrets/resinstack-nomad-vault-token-minicluster

    touch state/vault_done
fi

if [ ! -f state/consul_done ] ; then
    if [ ! -f secrets/resinstack-consul-gossip-key-minicluster ] ; then
        consul keygen > secrets/resinstack-consul-gossip-key-minicluster
    fi

    if [ ! -f state/consul_bootstrap.json ] ; then
        while ! consul acl bootstrap -format=json > state/consul_bootstrap.json 2>/dev/null ; do
            sleep 5
        done
    fi

    export CONSUL_HTTP_TOKEN=$(jq -r .SecretID < state/consul_bootstrap.json)
    terraform apply -target=module.consul_base -auto-approve

    consul acl token create -role-name consul-agent -format=json > state/consul_agent.json
    consul acl token create -role-name vault-server -format=json > state/consul_vault.json
    consul acl token create -role-name nomad-server -format=json > state/consul_nomad_server.json
    consul acl token create -role-name nomad-client -format=json > state/consul_nomad_client.json

    consul acl token create -policy-name global-management -format=json > state/consul_vault_integration.json

    jq -r .SecretID < state/consul_agent.json > secrets/resinstack-consul-agent-token-minicluster
    jq -r .SecretID < state/consul_vault.json > secrets/resinstack-vault-consul-token-minicluster
    jq -r .SecretID < state/consul_nomad_server.json > secrets/resinstack-nomad-server-consul-token-minicluster
    jq -r .SecretID < state/consul_nomad_client.json > secrets/resinstack-nomad-client-consul-token-minicluster

    vault write consul/config/access \
          address=consul.service.consul:8500 \
          token=$(jq -r .SecretID < state/consul_vault_integration.json)

    touch state/consul_done
fi

if [ ! -f state/nomad_done ] ; then
    nomad operator keygen > secrets/resinstack-nomad-gossip-key-minicluster

    while ! curl -o state/nomad_bootstrap.json -X POST $NOMAD_ADDR/v1/acl/bootstrap ; do
        sleep 5
    done
    export NOMAD_TOKEN=$(jq -r .SecretID < state/nomad_bootstrap.json)

    curl -o state/nomad_vault_auth.json \
         -X POST -d '{"Name": "Vault Integration", "Type": "management"}' \
         -H "X-Nomad-Token: $NOMAD_TOKEN" \
         $NOMAD_ADDR/v1/acl/token

    vault write nomad/config/access \
          address=http://nomad.service.consul:4646 \
          token=$(jq -r .SecretID < state/nomad_vault_auth.json)


    while ! terraform apply -target=module.nomad_base -auto-approve ; do
        sleep 5
    done

    touch state/nomad_done
fi
