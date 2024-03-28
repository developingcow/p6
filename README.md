Group member: Hong

Source for demo app: https://github.com/tastejs/todomvc  
# Diagram
![Cloud Architecture](https://github.com/developingcow/p6/assets/155276353/d9a21866-3e51-42cb-9ffd-3f6f094ffc38)


# Setup
Prereqs: AWS, Terraform
1. `terraform apply`
2. Log into the Jenkins instance hosted on one of the EC2 instances on port 8080
3. Install Suggested Plugins
4. Install nodejs plugin and ssh agent plugin
5. Go to manage tools > Tools > Set nodejs version
6. Add a version with an identifier referenced in the Jenkinsfile in the repo
7. Go to credentials > system unrestricted > add dockerpat as a username pair
8. Add your ssh key to ec2 instance as an ssh key (ssh)
9. Add the webhook `<url>:8080/github-webhook` to the repo settings
10. Add a new single pipeline job on Jenkins
11. Check or enter these: GitHub Hook Trigger, git repo url, pipeline script from scm, script path

When you push a new commit to GitHub, it will trigger a webhook and then a Jenkins job.  
The job will then build and test and deploy the new container image to the ec2 instance.

# Teardown
`terraform destroy`

## Notes:  
The app will be accessible at the external ip of the public ec2 instance.
