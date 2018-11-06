#!/bin/bash
oc new-project proj-gmapseta-dev --description="projeto: gmapseta DEV" --display-name="proj-gmapseta-dev"
oc new-project proj-gmapseta-uat --description="projeto: gmapseta UAT" --display-name="proj-gmapseta-uat"
oc new-project proj-gmapseta-prd --description="projeto: gmapseta PRD" --display-name="proj-gmapseta-prd"

oc policy add-role-to-group edit system:serviceaccounts:cicd-devtools -n proj-gmapseta-dev
oc policy add-role-to-group edit system:serviceaccounts:cicd-devtools -n proj-gmapseta-uat
oc policy add-role-to-group edit system:serviceaccounts:cicd-devtools -n proj-gmapseta-prd

oc new-build --name=gmapseta-api --image-stream=wildfly:10.1 --binary=true -n proj-gmapseta-dev
oc new-build --name=gmapseta-api --image-stream=wildfly:10.1 --binary=true -n proj-gmapseta-uat
oc new-build --name=gmapseta-api --image-stream=wildfly:10.1 --binary=true -n proj-gmapseta-prd

oc new-app gmapseta-api:latest --allow-missing-images -n proj-gmapseta-dev
oc rollout cancel dc/gmapseta-api -n proj-gmapseta-dev
oc set triggers dc -l app=gmapseta-api --containers=gmapseta-api --from-image=gmapseta-api:latest --manual -n proj-gmapseta-dev

oc new-app gmapseta-api:latest --allow-missing-images -n proj-gmapseta-uat
oc rollout cancel dc/gmapseta-api -n proj-gmapseta-uat
oc set triggers dc -l app=gmapseta-api --containers=gmapseta-api --from-image=gmapseta-api:latest --manual -n proj-gmapseta-uat

oc new-app gmapseta-api:latest --allow-missing-images -n proj-gmapseta-prd
oc rollout cancel dc/gmapseta-api -n proj-gmapseta-prd
oc set triggers dc -l app=gmapseta-api --containers=gmapseta-api --from-image=gmapseta-api:latest --manual -n proj-gmapseta-prd

#oc expose dc/gmapseta-api --port=8080 --hostname=gmapseta-api-dev.192.168.42.90.nip.io -n proj-gmapseta-dev
#oc expose dc/gmapseta-api --port=8080 --hostname=gmapseta-api-uat.192.168.42.90.nip.io -n proj-gmapseta-uat
#oc expose dc/gmapseta-api --port=8080 --hostname=gmapseta-api-prd.192.168.42.90.nip.io -n proj-gmapseta-prd
