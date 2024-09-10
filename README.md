# k3s_radicale

# Setup App Docker Container & Deployuent With Service
/bin/bash 1271JJ
Your development team requires to use online calendar that can scale. You were provided with request t alendar application called [radicalel (https://radicale.org/v3.html) •
As part of your setup, you are required to create radicale container and save it in your container reg icale deploymentment, physical volume claim and service to be accessed from the local network.

### Tasks
-  ⁠Setup docker container with radicale
  -⁠  ⁠Config should be mounted externally
  -  ⁠Ports need to be exposed
  -⁠  ⁠Dockerfile needs to be as small as possible
  -  ⁠Radicale needs initial password for login that needs to be set in config file. use env var to in:
-  ⁠Save container to registry, hub or any other
  -  ⁠Use multiple versions: stable, test, latest (according to radicale docs)
-⁠  ⁠Generate deployment, service, ingress and physical volume for radicale to deploy to k3s cluster

### Notes:
-  ⁠As usual:
  -  ⁠Setup new repo
  -  ⁠Use README Install ,Tasks and Contribution MD files for respected data
  - ⁠  ⁠Document each step
  -  ⁠Consider scenarious where it might fail and fix them before user gets there
-⁠  ⁠Add Todo list
  -⁠  ⁠List things that you think may be benefitial to this project
