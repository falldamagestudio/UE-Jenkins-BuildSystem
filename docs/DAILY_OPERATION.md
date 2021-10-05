## Change Jenkins configuration

* Change contents of `values/*`
* Run `./scripts/deploy-jenkins-controller.sh`.

This will restart Jenkins if necessary.

## Add/change/remove static agents

* Modify `environments/<env>/agents/terraform.tfvars`
* Run `./scripts/terraform-agents-apply.sh environments/<env>`.

Make sure that there are no build jobs running on any agents that are about to get terminated.

Note that it can take up to 20 minutes for a new agent to show up in the Jenkins UI.
Most of that time is spent pulling Docker images.

## Add/change/remove dynamic agents

* Modify `application/values/gce-config.yaml`
* Modify `environments/<env>/agents/terraform.tfvars`
* Run `./scripts/deploy-jenkins-controller.sh environments/<env>`
* Run `./scripts/terraform-agents-apply.sh environments/<env>`

Make sure that there are no build jobs running on any agents that are about to get terminated.

Note that it can take up to 30 minutes for a newly provisioned dynamic agent to show up in the Jenkins UI.
Most of that time is spent pulling Docker images. Starting up an already-existing agent is a lot quicker.

## Add/change/remove jobs

* Modify contents in the Jobs repo
* Run the Seed Job from within the Jenkins UI

## Restart Jenkins controller

Visit `https://<site URL>/safeRestart` in a web browser and click "Yes".

This will restart the Jenkins controller process, but it will not change
which Docker image is being used. For that to happen, you need to
force-recreate the Pod.

## Recreate Pod that runs Jenkins controller

Run `kubectl delete jenkins-controller-0`.

This ensures that the Jenkins controller runs the Docker image version of the
currently-installed Helm chart.

Deleting the pod will trigger auto-healing in Kubernetes. The pod will be recreated
with the Docker image link in the Helm chart.

This may interrupt ongoing builds. Most of Jenkins' state is persisted outside
of the pod though.

## Add or modify plugins in Jenkins

* First, do some work in the Images repo:
  * Modify `Docker/controller/plugins.txt`
  * Run `Docker/controller/update-plugins-with-dependencies.sh` to update the dependency tree
  * Build locally, for validation
  * Push to GitHub

* Wait for GitHub Actions to build new images
* Update URLs in `helm-config.json`
* Run `./scripts/deploy-jenkins-controller.sh`

This will restart Jenkins if necessary.

## Perform a major version update of Jenkins

* First, do lots of work in the Images repo:

  * Modify the FROM line of `Docker/controller/Dockerfile`
  * If there's a change to the Remoting version:
    * Update `Docker/controller/plugins.txt` to use a swarm plugin version compatible with the new Remoting version
    * Run `Docker/controller/update-plugins-with-dependencies.sh` to update the dependency tree
    * Update `Docker/agents/**/Dockerfile` to use agents with a matching Remoting version
    * Update `Docker/agents/*/swarm-agent/Dockerfile` to use a swarm client compatible with the new Remoting version
    * Update `Scripts/Linux/applications/install_jenkins_swarm_agent.sh` and `Scripts/Windows/Applications/ToolsAndVersions.psd1` to install a swarm client compatible with the new Remoting version
    * Build as many of these as you can locally, for validation
    * Push to GitHub

* Wait for GitHub Actions to build new images

* If there's a change to the Remoting version:
  * Put Jenkins into maintenance mode
  * Modify `environments/<env>/agents/terraform.tfvars` to refer to new images
  * Run `./scripts/terraform-agents-apply.sh environments/<env>` to update agent config
  * Delete all existing agent VMs
* Update URLs in `helm-config.json`
* Run `./scripts/deploy-jenkins-controller.sh`

This will restart Jenkins if necessary.
All agents might be gone. Trigger existing jobs once to recreate them and pre-populate them with state (downloading prebuilt UE, etc etc).
