module "consul_base" {
  source = "../../terraform-consul-base"

  anonymous_node_read    = true
  anonymous_service_read = true
  anonymous_agent_read   = true
}
