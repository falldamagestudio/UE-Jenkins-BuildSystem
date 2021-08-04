# Build Unreal Engine & games with Jenkins on GKE/GCE

This repo brings up a Kubernetes cluster in Google Kubernetes Engine. It installs Jenkins. It runs build jobs on on-demand provisioned VMs, or on statically-provisioned VMs, or directly on the Kubernetes cluster. Windows and Linux supported. All build jobs run within Docker containers.

# Status

This is still a proof-of-concept. We are not using it for production purposes yet.

![Jobs - Dynamic VMs](Jobs-DynamicVMs.png)
![Jobs - Static VMs](Jobs-StaticVMs.png)
![Jobs - Kubernetes](Jobs-Kubernetes.png)

# Goals

We want a CI/CD solution for our Unreal projects, which has these characteristics:
* App specific - supports building Unreal Engine applications, Engine & Game, clients & servers
* VCS support - supports Git + Plastic SCM
* OS support - Windows + Linux at least, potentially MacOS in the future
* Scalability - supports bursting and many different jobs, running some/all in parallel, without being very expensive to run
* Speed - can do incremental builds quickly, even when the build state is 100GB+
* Maintainability - Employ Infrastructure as Code & Configuration as Code, devs should be able to operate their own build system replicas
* Built upon Open Source software as much as possible
* Avoid writing a new build system

Jenkins is not fancy, but it supports all the above goals.

# Architecture

Terraform is used to create all infrastructure. This includes load balancers, storage buckets, and a Kubernetes cluster. The cluster has a couple of node pools, some of which scale dynamically based on demand.

Helm is used to deploy the Jenkins controller.

The Jenkins controller contains a Seed job. When the Seed job is run, a couple of Job DSL files are processed; these in turn create the engine/game specific jobs.

Terraform is used to create static VMs, and templates for dynamic agent VMs.

A modified version of Jenkins' GCE plugin is capable of creating and destroying agent VMs on-demand. These "dynamic" agent VMs can also be retained (changed to stopped state, instead of being destroyed) between jobs by the modfieid GCE plugin. This eliminates most of the cost for the dynamic VMs when they are not in use, while keeping the warm-up time for jobs low.

It is also possible to run jobs on Kubernetes. These will suffer from long image pull times when new nodes are provisioned. For incremental builds, the jobs will need to have PVCs provisioned.

Regardless of agent type, each agent has a single executor, and thus serves only one job at a time.

The Jenkins agent runs within a Docker container. Build jobs are also run within a Docker container (either via the Docker pipeline plugin, or via the Kubernetes pipeline plugin). The build tools container images contain all software necessary to build a typical UE engine or game on Linux and Windows.

# Agent types

## Dynamic VMs

The most cost-efficient way to use this is via Dynamic VMs. The GCE plugin maintains a small pool of VMs for each individual build job (or for each group of build jobs). These VMs are stopped when not in use; this maintains state on their disks, but at a relatively low cost. These VMs are relatively quick to start up (60-180 seconds depending on OS).

## Static VMs

These agents are ready to accept jobs at a moment's notice. However, be careful with costs!

## Kubernetes pods

These _can_ run UE jobs ... but it is rarely a good idea, [provisioning a new Windows node and pulling the required images can take 20 minutes](https://github.com/falldamagestudio/UE-Jenkins-BuildSystem/issues/20) and GKE does not allow us to modify the autoscaling logic. If you want to do incremental builds, you need to create PVCs within the Kubernetes cluster and change the corresponding jobs to use those PVCs. Incremental builds on GKE with autoscaling are not compatible with Plastic SCM, because Plastic needs to persist some info in the .plastic4 folder together with the workspace, and Jenkins Kubernetes plugin does not allow us enough control to persist that correctly.

Jobs run on Kubernetes should rather be things that run on Linux only, does not need so much state, and does not need large build tools containers.

## Self-hosted agents

You can start up a Swarm agent on any machine of your choosing, and point it to the internal IP of the Jenkins controller. The agent should connect and handle jobs. There is no automation to help with this in this repo though.

# Required skills

To setup and operate this, you need to be comfortable operating a diverse range of tech. This is not a turnkey solution. You _will_ spend time troubleshooting through the entire stack.

If you don't know the tech since before, you should expect to spend a fair bit of time as you figure out "why isn't my build personal system replica starting up properly?"

* Terraform
* Google Cloud Platform - Cloud Console, `gcloud`, `gsutil` - VMs, load balancers, cloud storage buckets, firewall rules, Google Kubernetes Engine, Secrets Manager, Service Accounts, IAM permissions
* Kubernetes - `kubectl`, `gcloud container`, `helm` - nodes, pods, secrets, yaml resource definitions
* Jenkins - JCasC, Groovy script, Job DSL, pipeline DSL

# Setup and teardown

See [SETUP_AND_TEARDOWN.md](SETUP_AND_TEARDOWN.md).

# Debugging and development

See [DEBUGGING_AND_DEVELOPMENT.md](DEBUGGING_AND_DEVELOPMENT.md).

# Daily operation

See [DAILY_OPERATION.md](DAILY_OPERATION.md).

# Useful references

See [REFERENCES.md](REFERENCES.md).

# License

See [LICENSE.md](LICENSE.md).
