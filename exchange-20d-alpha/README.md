# CI CD Pipeline

CI means Continuous Integration and CD means Continuous Delivery and Continuous Deployment.
The whole development cycle will be based on the dev-ops model with the help of dev-ops tools as well.
Jenkins is an open source tool critical for building CI/CD pipelines. It provides flexibility and many integrations — other tools critical to CI/CD have Jenkins plugins. This includes version control.

## Jenkins provides us with various interfaces and tools in order to automate the entire process:

1. Create new branch on working repository  
2. Dev team pushes code into their branch
3. Jenkins picks up the modified code from GitHub and create job for specific task
4. Jenkinsfile and it's components based on the specified stages and branch names (dev,staging,prod) decides phase cycle
5. After the code is working fine in staging server with unit testing, Same code then is deployed on the production server

## Overall CI/CD process:

* Jenkins builds application images
* Pushes them into ECR repository
* Deploys app pods on Kubernetes (depending on stage)
* Creates secrets for application database

# Added configurations:

1. Dockerfile for both folders api/web
2. Makefile for folders both api/web
3. Deployment yaml for folders both api/web
4. configs for stages for both folders api/web
5. Namespace yaml for both folders api/web
6. Secret create/update/inject in bin folder
7. Secret yaml for api
8. Script deploy.sh in main folder
9. Jenkinsfile in main folder
10. Gitignore file
11. Added Webhook
12. Manualy created repositories in ECR
13. Manualy gave execution permissions for scripts
14. Configured Jenkins through UI (Global credentials, Git credentials, Cloud, NewItem, Multibranch pipeline)


## With all the above steps, Jenkins is responsible for the delivery phase with automating the deployment of the application

# Sample three tier app

This repo contains code for a Node.js multi-tier application.

The application overview is as follows

```
web <=> api <=> db
```

The folders `web` and `api` describe how to install and run each app.

# ISSUES

1. Mistakes in config folders (version)
2. Forgot to apply role-binding before running pipeline
3. Confused namespaces for Jenkins and for the application
4. Forgot to add Jenkins port into cluster security group with my IP adress
5. Had to manualy create storage class for jenkins stateful set
6. Also had to manually apply ingress-nginx
7. Had problems with secrets, misconfigured some values. Solution: updated Makefile, and deployment.yaml in api