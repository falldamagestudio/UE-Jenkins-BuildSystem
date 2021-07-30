
# One-time setup

## Google Cloud setup

* Create a user and an organization in Google Cloud Platform.
* Set up a billing account for your organization. Provide credit card information.

## GitHub setup

* Create a GitHub organization for your company.

# Setup for each game / environment

You will need to do these steps once for the game. That will be your production environment. You will also need to do this once for each non-production environment of the build system.

# Decide on names and locations

You need to make a number of decisions early on:
* What's the name of your game? You will create a lot of resources that include that name.
* Which location do you want the build system to run in? Which GCP region + zone? Pick something close to you.
* What DNS hostname would you like the cluster to be present at?

## Google Cloud setup

* Create a new project in Google Cloud Platform (GCP). Name it as `<your game>-Jenkins-BuildSystem-<env>`.

* Delete the default VPC network.

* Delete the default Compute Engine Service Account.

* Visit APIs & Services | OAuth consent screen. Set up an Internal screen. Name it after the GCP project. Add your company's domain as an authorized domain. Choose no scopes.

* Visit the [Credentials](https://console.cloud.google.com/apis/credentials) screen. Create a new OAuth 2.0 Client ID, type `Web Application`, name `Jenkins Web Access`, authorized redirect URIs:
    * `http://localhost:8080/securityRealm/finishLogin`
    * `https://<DNS hostname>/securityRealm/finishLogin`
    * <magic URI from IAP>

* Create a bucket for Terraform state storage within the new project. Name it as `<GCP project>-state`. Place it in the same region that you intend to have other resources. Choose Standard default storage class. Choose Uniform access control.
* [Enable versioning](https://cloud.google.com/storage/docs/using-object-versioning) for the bucket.


## GitHub setup

First, make sure you have created a repository & GitHub user for your organization if you haven't done so already:

* Fork (if you want it public) or [Import](https://help.github.com/en/github/importing-your-projects-to-github/importing-a-repository-with-github-importer) (if you want it private) this repository to your company's GitHub organization, renaming it to `<your game>-Jenkins-BuildSystem`. Repeat the process for [https://github.com/falldamagestudio/UE-Jenkins-Images](UE-Jenkins-Images), [https://github.com/falldamagestudio/UE-Jenkins-Jobs](UE-Jenkins-Jobs), [https://github.com/falldamagestudio/UE-Jenkins-Engine](UE-Jenkins-Engine) and [https://github.com/falldamagestudio/UE-Jenkins-Game](UE-Jenkins-Game).

* Ensure you have a fork/import of Unreal Engine.

* Create a new GitHub account. GitHub Actions will use this account on behalf of your organization. Name it something like `<your game>-jenkins-buildsystem`. Give it admin access to your Unreal Engine repository, `<org>/<your game>-Jenkins-Engine` and `<org>/<your game>-Jenkins-Game`.

* Create a Personal Access Token for the GitHub Account (either build system account or your personal account), with name `Access Token for GitHub Actions in <org>/<your game>-Jenkins-*` and scopes `admin:repo_hook`, `repo`, `workflow`.

## Plastic setup

* If you will be using Plastic, create a new Plastic account and give it access to suitable repositories.

## First-time system bring-up

* Clone this repo to your local machime.
* Make a copy of `environments/falldamage/` to `environment/<env>/`.

### Bring up core

* Modify settings in the following files:
    * `environments/<env>/core/backend.tf` -> this should point to the new Terraform state bucket
   * `environments/<env>/core/terraform.tfvars`
	( Note, "project number" can be found out by doing `gcloud projects list`)

* Create the core infrastructure: `./scripts/terraform-core-apply.sh environments/<env>/`

* Once this is done, you should be able to see [a new network + subnetwork](https://console.cloud.google.com/networking/networks/list), some [Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts), and some extra [storage buckets](https://console.cloud.google.com/storage/browser) in GCP.

### Build Docker & VM images

* Add some secrets to your Images repository:
    * `ARTIFACT_REGISTRY_LOCATION` - take value from `core/terraform.tfvars`
    * `GOOGLE_CLOUD_BUILD_ARTIFACT_UPLOADER_SERVICE_ACCOUNT_KEY` - create a key for the `build-artifact-uploader@<project>.iam.gserviceaccount.com` Service Account
    * `GOOGLE_CLOUD_CONFIG_STORAGE_BUCKET` - take value from `core/terraform.tfvars`
    * `GOOGLE_CLOUD_IMAGE_BUILDER_INSTANCE_CONTROLLER_SERVICE_ACCOUNT_KEY` - create a key for the `image-builder-instance-ctl@<project>.iam.gserviceaccount.com` Service Account
    * `GOOGLE_CLOUD_PROJECT_ID` - take from core/terraform.tfvars`
    * `GOOGLE_CLOUD_REGION` - take value from `core/terraform.tfvars`
    * `GOOGLE_CLOUD_ZONE` - take value from `core/terraform.tfvars`

* Trigger all the workflows in the repository.

* Give it an hour or so. You should now be able to see the Docker images within [Artifact Registry in GCP](https://console.cloud.google.com/artifacts), and the VM images within the [VM images list in GCP](https://console.cloud.google.com/compute/images).

### Bring up kubernetes

* Modify settings in the following files:
** `environments/<env>/kubernetes/backend.tf` -> this should point to the new bucket
** `environments/<env>/kubernetes/core_state.tf` -> this should point to the new bucket
** `environments/<env>/kubernetes/terraform.tfvars`

** `./scripts/terraform-kubernetes-apply.sh environments/<env>/`

* Once this is done, you should be able to see the empty Kubernetes cluster using GCP tools.

* Set up `kubectl` to access the cluster: `gcloud container clusters get-credentials jenkins` / `kubectl config get-contexts`.

* Copy the cluster name string into `environments/<env>/kube-config.json`.

### Provide manual cluster configuration

* Perform `./scripts/set-github-pat.sh environments/<env>/ <GitHub PAT>`.
* Perform `./scripts/set-manual-config.sh environments/<env>/ <Google OAuth2 Client ID> <Google OAuth2 Client Secret> <DNS hostname>`. The OAuth2 parameters can be found among the details of the OAuth 2.0 Client ID that you previously created (see the [Credentials](https://console.cloud.google.com/apis/credentials) screen).

### Deploy Jenkins controller

* Update all Docker image URLs in `environments/<env>/helm-config.json` to point to images present in [Artifact Registry](https://console.cloud.google.com/artifacts).

* Set `plastic` to `true` or `false` in `environments/<env>/helm-config.json` depending on whether you will use Plastic SCM.

* Modify `seed_job_url` in `environments/<env>/helm-config.json` to point to your own replica of the repo.

* Perform `./scripts/deploy-jenkins-controller.sh environments/<env>/`.

* Configure a DNS entry that points to `jenkins-controller-external-ip-address`'s address.

* Wait until everything - including [ingresses](https://console.cloud.google.com/kubernetes/ingresses?project=kalms-ue-jenkins-buildsystem) - are operational. Load balancing, routing, and SSL cert handling can be a bit off and on for some time (an hour?).

### Finish IAP configuration

* Visit `<DNS hostname>` in a browser. You will be met with a HTTP 400 Authorization Error message. Add the redirect URI to the list of allowed domains in the OAuth 2.0 Client ID configuration (see the [Credentials](https://console.cloud.google.com/apis/credentials) screen).

* Visit `<DNS hostname>` again. You probably need to log in twice.

### Patch up GCE plugin a bit

* Visit [Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts). Create a service account key for `gce-plugin-for-jenkins@<project>.iam.gserviceaccount.com`. Add this key to Jenkins as "Google Service Account from private key".

* Restart Jenkins.

### Bring up agent vms

* Modify settings in the following files:
** `environments/<env>/agents/backend.tf` -> this should point to the new bucket
** `environments/<env>/agents/core_state.tf` -> this should point to the new bucket
** `environments/<env>/agents/terraform.tfvars` - be aware

** `./scripts/terraform-agents-apply.sh environments/<env>/`

### Provide manual agent configuration

* Log in to Jenkins. Create an API token for one user.
* Perform `./scripts/set-swarm-config.sh <username> <API token>`.
* If you will use Plastic SCM, perform `./scripts/set-plastic-config.sh environments/<env>/ <username> <encrypted password> <server> <encrypted content encryption key>`. Use `cm crypt <string>` to encrypt password & content encryption key.
* Restart Jenkins and any agents that happened to be running at the time.

### Populate with jobs

* Trigger the Seed Job. This will populate your Jenkins instance with build jobs.

* Your build system should now be ready to rock.

## Tear down infrastructure

* Uninstall Jenkins controller from Jenkins cluster with: `helm uninstall jenkins-controller`
* Remove agent VMs with: `./scripts/terraform-agents-destroy.sh environments/<env>/`
* Delete Kubernetes cluster with: `./scripts/terraform-kubernetes-destroy.sh environments/<env>/`
* Delete all remaining resources with: `./scripts/terraform-core-destroy.sh environments/<env>/` -- note that this will delete all VM images, Docker images, and all pre-built UE versions and any games which you have uploaded using Longtail
