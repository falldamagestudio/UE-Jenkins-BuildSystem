# Build Unreal Engine & games with Jenkins on GCE

# Overview

This is a [Jenkins](https://www.jenkins.io/)-based build system that runs on [Google Compute Engine (GCE)](https://cloud.google.com/compute). It is designed to build Unreal Engine and UE-based games. Windows and Linux targets supported.

Build jobs are typically run on VMs whose disks are persistent (to support quick incremental builds) but are started/stopped as necessary (to reduce cost).

You can access the Jenkins UI directly over the Internet; it is protected using [Identity-Aware Proxy](https://cloud.google.com/iap). 

The build system is complex to operate, and pricey, but it is reliable and convenient for users.

# Differences from v1.x

v1.x (available [here](https://github.com/falldamagestudio/UE-Jenkins-BuildSystem/tree/1.x)) ran the Jenkins controller on a single-node GKE cluster. V2.x runs the controller natively on a VM, with Ansible as the control mechanism. This means that there are fewer moving parts, and it's easier to troubleshoot when something goes wrong.


# Status

V2.x is still in development.

We are using v1.x in production.

Example jobs:

![Jobs - Dynamic VMs](docs/images/Jobs-DynamicVMs.png)

There are some other jobs, which are mainly for R&D purposes:

![Jobs - Static VMs](docs/images/Jobs-StaticVMs.png)
![Jobs - Kubernetes](docs/images/Jobs-Kubernetes.png)

# Architecture

![System architecture](docs/images/SystemArchitecture.png)

# Operation

![Operation](docs/images/Operation.png)

[Terraform](https://www.terraform.io/) is used to create all infrastructure. This includes load balancers, storage buckets, the VM which the controller will run on, and VM templates for any build agents.

[Ansible](https://docs.ansible.com/) is used to control the Jenkins controller as well as its companion agent (used for non resource intensive maintenance jobs).

The Jenkins controller contains a Seed job. When the Seed job is run, a couple of [Job DSL](https://jenkinsci.github.io/job-dsl-plugin/) files are processed; these in turn create the engine/game specific jobs.

[A modified version of Jenkins' GCE plugin](https://github.com/falldamagestudio/google-compute-engine-plugin) is capable of creating and destroying agent VMs on-demand. These "dynamic" agent VMs can also be retained (changed to stopped state, instead of being destroyed) between jobs by the modified GCE plugin. This eliminates most of the cost for the dynamic VMs when they are not in use, while keeping the warm-up time for jobs low.

Each agent has a single executor, and thus serves only one job at a time.

The Jenkins agent and all build tools are installed directly onto the VM, and build jobs are run directly on the VM as well.

# Agent types

## Dynamic VMs (Recommended for GCP)

The most cost-efficient way to use this on GCP is via Dynamic VMs. The GCE plugin maintains a small pool of VMs for each individual build job (or for each group of build jobs). These VMs are stopped when not in use; this maintains state on their disks, but at a relatively low cost. These VMs are relatively quick to start up (30-60 seconds depending on OS).

## Self-hosted agents (recommended for on-premises hardware)

You can start up a Swarm agent on any machine of your choosing, and point it to the internal IP of the Jenkins controller, assuming that you have connected your company network to the agent network in GCP. The agent should connect and handle jobs. There is no automation to help with this in this repo though.

# Security considerations

This build system is designed to be safe to expose to the Internet.

## Controller

The Jenkins controller runs within a Docker container on the controller VM.

It is exposed to the Internet via a load balancer.
Identity-Aware Proxy is enabled for that load balancer. This ensures that anyone who wants to send HTTP traffic to the Jenkins controller has authenticated with a Google account on your internal domain first. Non-authenticated HTTP calls will not reach the Jenkins controller and can therefore not be used to exploit security holes.

The Jenkins controller also exposes an internal load balancer. This is not behind IAP. It is the entry point for any incoming traffic (for example, Swarm agents) that needs to talk to Jenkins but is not IAP-compatible.

## Agents

Agents run in their own network, separate from the controller VM. They have a few ports open to the Internet (typically WinRM & SSH). They have a route to the internal load balancer.

## Image builders

Image builders run in a separate network, with no connectivity to the agents or the controller. They have a few ports (WinRM & SSH) open to the Internet.

## Storage

Storage buckets are accessible to the Internet, but have tightly-defined access rules: only the intended Service Accounts and user groups can access their content.

# Performance considerations

## Parallel jobs

This build system is intended to have many independent agents - in the extreme case, one unique agent per job. When many jobs want to run at the same time, these agents (in the form of Dynamic VMs) can start up and run independently of each other. This minimizes queue problems.

## Single-builder throughput

Individual VMs can be scaled from ~4 to 96 vCPUs.

`pd-standard` disks are a bottleneck, don't use those. `pd-balanced` become bottlenecks for 32+ vCPU machines (but may overall be the most cost effective option). `pd-ssd` sustain 64+ vCPU VMs well.

## Cold start latency

Expect 60-90 seconds to provision & start a new VM if one doesn't exist.

## Hot start latency

Expect ~60 seconds to start a VM, if the job previously has been run, and there is a persisted disk.

# Cost considerations

GCP wins on flexibility, but a well-run on-premises cluster is cheaper than anything on GCP.

In our case - team of 50 developers, a couple of CI jobs run on every commit, a couple of manually-triggered jobs - the system costs $20/day during weekends and $70/day during workdays. This adds up to $1700/month.

There are some cost cutting measures that you can do on GCP with this build system:
- Being careful with disk sizes (do you really need X GB for job Y?) and disk type (`pd-ssd` vs `pd-balanced`) reduces the disk rental costs.
- Being careful with CPUs for jobs (do you really need X cores for job Y?) reduces the CPU & Windows license costs, but may increase build times.

Using preemptive VMs would cut rental costs 50-80% further for CPU & RAM, but it causes reliability problems - jobs terminated midway, sometimes there's no machine available - and the modified GCE plugin doesn't handle it well enough yet (see [#54](https://github.com/falldamagestudio/UE-Jenkins-BuildSystem/issues/54)) so it is probably not worthwhile for you.

The big remaining costs on GCP are:
- Disk rental costs remain even with Dynamic VMs. This turns into a static cost that goes up with the number of build jobs. If the GCE plugin was able to snapshot disks when they aren't used for a long time, it could cut those costs further (see [#53](https://github.com/falldamagestudio/UE-Jenkins-BuildSystem/issues/53)).
- Windows OS license cost is significant. The more jobs you can run on Linux, the more you save. Perhaps we can build for Windows targets on Linux (see [#55](https://github.com/falldamagestudio/UE-Jenkins-BuildSystem/issues/55))?

# Required skills

To setup and operate this, you need to be comfortable operating a diverse range of tech. This is not a turnkey solution. You _will_ spend time troubleshooting through the entire stack.

If you don't know the tech since before, you should expect to spend a fair bit of time as you figure out "why isn't my build personal system replica starting up properly?"

You will use at least this on a regular basis:
* Terraform
* Scripting languages - Bash, PowerShell
* Google Cloud Platform - Cloud Console, `gcloud`, `gsutil` - VMs, load balancers, cloud storage buckets, firewall rules, Google Kubernetes Engine, Secrets Manager, Service Accounts, IAM permissions
* Docker - docker, compose - manage & inspect containers
* Ansible - homewritten roles & playbooks
* Systemd - install and manage custom-made services
* Jenkins - JCasC, Groovy script, Job DSL, pipeline DSL

# Setup and teardown

See [SETUP_AND_TEARDOWN.md](docs/SETUP_AND_TEARDOWN.md).

# Debugging and development

See [DEBUGGING_AND_DEVELOPMENT.md](docs/DEBUGGING_AND_DEVELOPMENT.md).

# Daily operation

See [DAILY_OPERATION.md](docs/DAILY_OPERATION.md).

# Useful references

See [REFERENCES.md](docs/REFERENCES.md).

# License

See [LICENSE.txt](LICENSE.txt).

# Further reading

Here is [a blog post](https://blog.falldamagestudio.com/posts/modern-jenkins-for-unreal-engine/) that provides more motivation and background details about the build system.
