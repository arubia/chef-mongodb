ENV['BSON_EXT_DISABLED'] = "true"

node.set['mongodb']['is_replicaset'] = false
node.set['mongodb']['cluster_name'] = node['mongodb']['cluster_name']

include_recipe "mongodb::install"
include_recipe 'mongodb::mongo_gem'

Chef::Log.info "Configuring replicaset with OPSWORKS REPLICASET"

unless node['mongodb']['is_shard']
  # assuming for the moment only one layer for the replicaset instances
  replicaset_layer_slug_name = node['opsworks']['instance']['layers'].first
  replicaset_layer_instances = node['opsworks']['layers'][replicaset_layer_slug_name]['instances']

  replicaset_members = Chef::ResourceDefinitionList::OpsWorksHelper.replicaset_members(node)

  Chef::ResourceDefinitionList::MongoDB.configure_replicaset(node, replicaset_layer_slug_name, replicaset_members)
end
