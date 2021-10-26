resource "google_compute_instance_from_template" "static_build_agent" {

    for_each = var.static_agents

    name = each.key

    source_instance_template = google_compute_instance_template.agent_template[each.value.template].id

    metadata = merge(
        google_compute_instance_template.agent_template[each.value.template].metadata,
        { jenkins-labels = each.value.jenkins_labels })
}
