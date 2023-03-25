locals {

    # Flatten hierarchical notation into a linear list of templates:
    #
    # [{
    #   vm_image_name : "image1"
    #   agent_templates = {
    #       template1 = { machine_type = "type1", ... }
    #       template2 = { machine_type = "type2", ... }
    #   }
    # },{
    #   vm_image_name : "image2"
    #   agent_templates = {
    #       template3 = { machine_type = "type3", ... }
    #   }
    # }]
    #
    # =>
    #
    # {
    #   template1 = { vm_image_name : "image1", machine_type = "type1", ... }
    #   template2 = { vm_image_name : "image1", machine_type = "type2", ... }
    #   template3 = { vm_image_name : "image2", machine_type = "type3", ... }
    # }


    agent_templates_flattened = merge([
        for agent_template_group in var.agent_template_groups : {
            for agent_template_name, agent_template_parameters in agent_template_group.agent_templates : agent_template_name => {
                vm_image_name = agent_template_group.vm_image_name
                machine_type = agent_template_parameters.machine_type
                boot_disk_type = agent_template_parameters.boot_disk_type
                boot_disk_size = agent_template_parameters.boot_disk_size
                preemptible = agent_template_parameters.preemptible
            }
        }
    ]...)
}
module "agents" {

    source = "../../../../infrastructure/agents"

    project_id = data.terraform_remote_state.core.outputs.project_id
    zone = data.terraform_remote_state.core.outputs.zone

    agent_vms_network = data.terraform_remote_state.core.outputs.agent_vms_network
    agent_vms_subnetwork = data.terraform_remote_state.core.outputs.agent_vms_subnetwork

    internal_ip_address = data.terraform_remote_state.core.outputs.internal_ip_address

    longtail_store_bucket_name = data.terraform_remote_state.core.outputs.longtail_store_bucket_name

    windows_vm_ssh_public_key = data.terraform_remote_state.core.outputs.ssh_vm_public_key_windows

    swarm_agent_username = data.terraform_remote_state.controller.outputs.swarm_agent_username
    swarm_agent_api_token = data.terraform_remote_state.controller.outputs.swarm_agent_api_token

    agent_templates = local.agent_templates_flattened
}
