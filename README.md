# TGC.Landingzones

This repository is a personal landingzone setup for easier provisioning repository and base setup for whatever (more or less) brilliant ideas I get to never complete.

The simple purpose is, so I quicker can start doing actual development instead of having to setup SPN, Azure access, base resources, plumbing and what not.

It basically, allows me to add a new JSON file (See `Landingzones` folder) to configure a new project.

My landingzone setup supports the following:
* Creates a GitHub repository
* Creates Azure Resource Group(s)
* Configure a SPN with access to said Azure Resource Group(s)
* Configure access to shared resources (e.g. Azure Container Registry if needed)
* Access to shared Log Analytic Workspace
* Configure Federated SPN credentials as Github secrets to use in pipelines
* Creates a default repository structure based on a default repository
* Creates root DNS Zones for propagating Child zones (if needed) - Still Work-in-Progress