Group member: Hong

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
