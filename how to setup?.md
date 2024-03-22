how to setup?
install suggested plugin

install node js plugin
instal ssh agent plugin
manage tools > tools > set node js version > add with an identifier
add sshagent
reference those id in dockerfile

credentails under system unrestricted:
add dockerpat as username pair
add ssh key as "ssh", user ubuntu

open jenkins create new job, github hook trigger , add git repo url
pipeline script from scm, script path Jenkinsfile


Add this to webhook in repo settings http://<ip>:8080/github-webhook/