/*
locals {
    agent_templates_flattened = concat(flatten([
        for agent_template_group in var.dynamic_agent_template_groups : [
            for agent_template in agent_template_group.agent_templates : { name : {
                    type = "dynamic"
                    os = agent_template_group.os
                    vm_image_name = agent_template_group.vm_image_name
                    machine_type = agent_template.machine_type
                    boot_disk_type = agent_template.boot_disk_type
                    boot_disk_size = agent_template.boot_disk_size
                    preemptible = agent_template.preemptible
                }
            }
        ]
    ]),
    flatten([
        for agent_template_group in var.static_agent_template_groups : [
            for agent_template in agent_template_group.agent_templates : { name : {
                    type = "static"
                    os = agent_template_group.os
                    vm_image_name = agent_template_group.vm_image_name
                    machine_type = agent_template.machine_type
                    boot_disk_type = agent_template.boot_disk_type
                    boot_disk_size = agent_template.boot_disk_size
                    preemptible = agent_template.preemptible
                }
            }
        ]
    ]))
}
*/

locals {
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

    source = "../../../infrastructure/agents"

    project_id = data.terraform_remote_state.core.outputs.project_id
    zone = data.terraform_remote_state.core.outputs.zone

    agent_vms_network = data.terraform_remote_state.core.outputs.agent_vms_network
    agent_vms_subnetwork = data.terraform_remote_state.core.outputs.agent_vms_subnetwork

    internal_ip_address = data.terraform_remote_state.core.outputs.internal_ip_address

    longtail_store_bucket_name = data.terraform_remote_state.core.outputs.longtail_store_bucket_name

    windows_vm_ssh_public_key = data.terraform_remote_state.core.outputs.ssh_vm_public_key_windows

    agent_templates = local.agent_templates_flattened

    static_agents = var.static_agents
}
