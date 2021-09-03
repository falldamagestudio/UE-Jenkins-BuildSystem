# Build Unreal Engine & games with Jenkins on GKE/GCE

This repo brings up a Kubernetes cluster in Google Kubernetes Engine. It installs Jenkins. It runs build jobs on on-demand provisioned VMs, or on statically-provisioned VMs, or directly on the Kubernetes cluster. Windows and Linux supported. Build jobs run either within Docker containers (on GKE or on VMs), or directly on VMs.

# Status

This is still a proof-of-concept. We are just about to begin using it for production.

![Jobs - Dynamic VMs](Jobs-DynamicVMs.png)
![Jobs - Static VMs](Jobs-StaticVMs.png)
![Jobs - Docker Dynamic VMs](Jobs-DockerDynamicVMs.png)
![Jobs - Docker Static VMs](Jobs-DockerStaticVMs.png)
![Jobs - Kubernetes](Jobs-Kubernetes.png)

# Goals

We want a CI/CD solution for our Unreal projects, which has these characteristics:
* App specific - supports building Unreal Engine applications, Engine & Game, clients & servers
* VCS support - supports Git + Plastic SCM
* OS support - Windows + Linux at least, potentially MacOS in the future
* Scalability - supports bursting and many different jobs, running some/all in parallel, without being very expensive to run
* Speed - can do incremental builds quickly, even when the build state is 100GB+
* Maintainability - Employ Infrastructure as Code & Configuration as Code, devs should be able to operate their own build system replicas
* Security - can be exposed to the Internet without too much risk, people use Google accounts for auth
* Built upon Open Source software as much as possible
* Avoid writing a new build system

Jenkins is not fancy, but it supports all the above goals.

# Architecture

Terraform is used to create all infrastructure. This includes load balancers, storage buckets, and a Kubernetes cluster. The cluster has a couple of node pools, some of which scale dynamically based on demand.

Helm is used to deploy the Jenkins controller.

The Jenkins controller contains a Seed job. When the Seed job is run, a couple of Job DSL files are processed; these in turn create the engine/game specific jobs.

Terraform is used to create static VMs, and templates for dynamic agent VMs.

A modified version of Jenkins' GCE plugin is capable of creating and destroying agent VMs on-demand. These "dynamic" agent VMs can also be retained (changed to stopped state, instead of being destroyed) between jobs by the modified GCE plugin. This eliminates most of the cost for the dynamic VMs when they are not in use, while keeping the warm-up time for jobs low.

It is also possible to run jobs on Kubernetes. These will suffer from long image pull times when new nodes are provisioned. For incremental builds, the jobs will need to have PVCs provisioned.

Regardless of agent type, each agent has a single executor, and thus serves only one job at a time.

For Kubernetes, and Docker VMs: The Jenkins agent runs within a Docker container. Build jobs are also run within a Docker container (either via the Docker pipeline plugin, or via the Kubernetes pipeline plugin). The build tools container images contain all software necessary to build a typical UE engine or game on Linux and Windows.

For non-Docker VMs: The Jenkins agent and all build tools are installed directly onto the VM, and build jobs are run directly on the VM as well.

# Agent types

## Dynamic VMs (Recommended for GCP)

The most cost-efficient way to use this on GCP is via Dynamic VMs. The GCE plugin maintains a small pool of VMs for each individual build job (or for each group of build jobs). These VMs are stopped when not in use; this maintains state on their disks, but at a relatively low cost. These VMs are relatively quick to start up (30-60 seconds depending on OS).

## Static VMs

These agents are ready to accept jobs at a moment's notice. However, be careful with costs!

## Dynamic / Static Docker VMs

These are similar to the Dynamic / Static VMs, except that all the lifting is done from within Docker containers.
The main benefit here is that the game repo can contain the Docker image ID for the build tools, thereby versioning the build environment within the game repo. However, these suffer from slow boot times at first provisioning (Windows machines can take 15 minutes to provision, pull down the Jenkins agent image, and another 15 minutes to pull the build tools image). It is also more difficult to debug build job problems inside of a Windows container than outside.

Given the operational problems, there is no compelling reason to use Docker VMs.

## Kubernetes pods 

These _can_ run UE jobs ... but it is rarely a good idea when run on auto-scaled GKE, since [provisioning a new Windows node and pulling the required images can take 20 minutes](https://github.com/falldamagestudio/UE-Jenkins-BuildSystem/issues/20) and GKE does not allow us to modify the autoscaling logic. If you want to do incremental builds, you need to create PVCs within the Kubernetes cluster and change the corresponding jobs to use those PVCs. Incremental builds on GKE with autoscaling are not compatible with Plastic SCM, because Plastic needs to persist some info in the .plastic4 folder together with the workspace, and Jenkins Kubernetes plugin does not allow us enough control to persist that correctly.

Jobs run on Kubernetes should rather be things that run on Linux only, does not need so much state, and does not need large build tools containers.

Jobs run on Kubernetes might make sense for an on-premises OpenShift cluster. Since the nodes won't be dynamically-provisioned there, the Docker containers will quickly be cached on all nodes. However, the Plastic
compatibility problems remain unsolved; you'd need to sort that out yourself.

## Self-hosted agents (recommended for on-premises hardware)

You can start up a Swarm agent on any machine of your choosing, and point it to the internal IP of the Jenkins controller. The agent should connect and handle jobs. There is no automation to help with this in this repo though.

# Security considerations

This build system is designed to be safe to expose to the Internet.

## Controller

The Jenkins controller runs within GKE.

It is exposed to the Internet via a load balancer.
Identity-Aware Proxy is enabled for that load balancer. This ensures that anyone who wants to send HTTP traffic to the Jenkins controller has authenticated with a Google account on your internal domain first. Non-authenticated HTTP calls will not reach the Jenkins controller and can therefore not be used to exploit security holes.

The Jenkins controller also exposes an internal load balancer. This is not behind IAP. It is the entry point for any incoming traffic (for example, Swarm agents) that needs to talk to Jenkins but is not IAP-compatible.

## Agents

Agents run in their own network, separate from the GKE cluster. They have a few ports open to the Internet (typically WinRM & SSH). They have a route to the internal load balancer.

## Image builders

Image builders run in a separate network, with no connectivity to the agents or the controller. They have a few ports (WinRM & SSH) open to the Internet.

## Storage

Any storage buckets have tightly-defined access rules: only the intended Service Accounts can use them.

# Performance considerations

## Parallel jobs

This build system is intended to have many independent agents - in the extreme case, one unique agent per job. When many jobs want to run at the same time, these agents (in the form of Dynamic VMs) can start up and run independently of each other. This reduces queue problems.

## Single-builder throughput

Individual VMs can be scaled from ~4 to 96 vCPUs.

pd-standard disks are a bottleneck, don't use those. pd-balanced become bottlenecks for 32+ vCPU machines (but may overall be the most cost effective option). pd-ssd sustain 64+ vCPU VMs well.

## Cold start latency

Expect 60-90 seconds to provision a new VM if one doesn't exist.

## Hot start latency

Expect ~60 seconds to provision a VM, if the job previously has been run, and there is a persisted disk.

# Cost considerations

GCP wins on flexibility, but a well-run on-premises cluster is cheaper than anything on GCP.

There are some cost cutting measures that you can do on GCP with this build system:
- Dynamic VMs reduce the CPU, RAM & OS license rental costs.
- Using preemptive VMs cust rental costs 50-80% further for CPU & RAM rental costs. This can cause reliability problems - jobs terminated midway, sometimes there's no machine available - but the price diff is probably worth it for you.
- Being careful with disk sizes (do you really need X GB for job Y?) and disk type (pd-ssd vs pd-balanced) reduces the disk rental costs.

The big remaining costs on GCP are:
- Disk rental costs remain even with Dynamic VMs. This turns into a static cost that goes up with the number of build jobs. If the GCE plugin was able to snapshot disks when they aren't used for a long time, it could cut those costs further.
- Windows OS license cost is significant. The more jobs you can run on Linux, the more you save.

# Required skills

To setup and operate this, you need to be comfortable operating a diverse range of tech. This is not a turnkey solution. You _will_ spend time troubleshooting through the entire stack.

If you don't know the tech since before, you should expect to spend a fair bit of time as you figure out "why isn't my build personal system replica starting up properly?"

You will use at least this on a regular basis:
* Terraform
* Scripting languages - Bash, PowerShell
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
