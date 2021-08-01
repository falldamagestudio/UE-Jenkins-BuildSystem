## An agent is not showing up in the Jenkins UI

* Inspect logs in Jenkins. Any relevant errors?

* Find the instance in the Google Cloud Console. Click on "Cloud Logging". Check the logs, any hints?

Linux only:
* Use `gcloud compute ssh` to log on to the machine
* Force the agent service to stop via `sudo systemctl start jenkins-agent.service`
* Inspect logs in `/mnt/disks/persistent-disk/agent/remoting/logs`, any hints?

Windows only:
* Use `gcloud compute reset-windows-password` to prepare a Windows account
* [Connect to the instance using PowerShell](https://cloud.google.com/compute/docs/instances/windows/connecting-powershell).
* Force the agent service to stop via `Stop-Service JenkinsAgent`
* Inspect logs in `C:\J\Remoting\Logs`, any hints?

## Jenkins controller is not starting up properly (UI does not become available)

* Check which state the controller pod is in, `kubectl get pods jenkins-controller-0`
* Check Jenkins controller logs, `kubectl logs jenkins-controller-0 -c jenkins`

## Plastic jobs get stuck at startup / unable to find jenkinsfiles

Is the only line of output is: `<timestamp>  Started by user <username>`, the Jenkinsfile is not being fetched, it's not being assigned to any machine? Then it is probably the Plastic server/username/password that is incorrect.

If the master doesn't find the Jenkinsfile, then either the server/reponames are incorrect, the path to the Jenkinsfile is incorrect, or the cloud content encryption server/password is incorrec.

* Log in to jenkins controller machine, `kubectl exec -it jenkins-controller-0 -c jenkins -- /bin/bash`

* Verify username/password, `cm lrep <server>`

* Verify server + cloud content encryption password, `cm cat serverpath:<path to jenkins groovy script in repo>#br:/main@<reponame>@<server>`

* Iterate with `./scripts/set-plastic-config.sh` and redeploy the controller pod after each time, `kubectl delete pods jenkins-controller-0`

## Iterating on Windows agent VM images

* Start up a VM (either blank Windows, or a pre-made agent VM)
* Prepare one Linux terminal, and two Windows terminals
* Set up remote WinRM session from both Windows terminals to the VM
* Edit code with VS Code against WSL
* Use the Linux terminal to copy files from WSL to the local Windows machine
* Run tests via `Invoke-Pester`
* Use Windows terminal 1 to copy files from the local Windows machine to the VM
* Use Windows terminal 2 to run things and inspects results on the VM

## Iterating on Linux agent VM images

* Set up Terraform to deploy a Linux VM of the appropriate type
* Ensure you have `UE-Jenkins-BuildSystem` and `UE-Jenkins-Images` repos cloned as siblings on your local machine
* Modify one of the `builder_vm_templates.tf` to pick up cloud-init config from local disk
* Modify the appropriate `*-cloud-config.yaml` file
* Run `./scripts/terraform-agents-apply.sh environments/<env>` to create VM if necessary, and apply your locally-modified cloud config to it
* Restart VM to pick up changes

## Iterating on Windows Docker images

* Similar to iterating on Windows agent VM images:
* Develop code under WSL
* Copy to Windows side
* Verify tests via `Invoke-Pester`
* Copy to remote VM
* Run scripts directly on machine, inspect results
* Build container on machine
* Test-run container on machine
* Tag & push container to remote repo using ":test" tag
* Redeploy Jenkins controller with the ":test" tag
* Test-run builds via Jenkins UI

## Iterating on Linux Docker images

* Similar to iterating on Windows agent VM images:
* Develop code under WSL
* Build container on local machine
* Test-run container on local machine
* Tag & push container to remote repo using ":test" tag
* Redeploy Jenkins controller with the ":test" tag
* Test-run builds via Jenkins UI
