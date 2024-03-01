# What are we deploying?
A GitLab CI/CD environment to develop and test code projects collaboritavely.
- [GitLab](https://hub.docker.com/r/gitlab/gitlab-ce): This container is GitLab itself. This is where you'll develop your projects, manage collaborators, and manage your CI/CD pipeline..
- [GitLab-Runner](https://hub.docker.com/r/gitlab/gitlab-runner): This container is what will run our code for testing purposes.

# Rationale
As I expand my devOps skillset, I figured I should probably start on the actual developer part. Creating an environment to develop and test my code was the logical first step. 

# Before we get started...
These are some recommendations that might make things a little easier for you, but **are not required** as everyone has their own system and workflow for maintaining their services.
- An SMTP proxy like [Mailjet](https://www.mailjet.com/) if you want your GitLab instance to send out notifications via email.
- An LDAP server for centralized authentication across your services.
- An application like [Portainer](https://docs.portainer.io/start/install/server/docker/linux) to help manage the containers you'll be creating. This tool is invaluable for troubleshooting and monitoring your containers (in my opinion).
- A service like [Tailscale](https://tailscale.com/) to allow you to remotely manage your services (and facilitate secure remote streaming). You can find installation documentation for your OS [here](https://tailscale.com/download/). 
- A Debian-based machine for your Docker host. I run my services on a Ubuntu Server host, so this tutorial was designed for that operating environment.

# Let's begin!

## Deploying our services

### Deployment through Portainer's "stacks" feature
Typically, docker-compose.yml's are deployed through the docker-compose CLI command. However, Portainer has built-in support for deploying your Docker-Compose files. Portainer's built-in compose editor will point out errors in your .yaml/.yml and give you a simple interface to control administrative permissions.
1. In the Portainer UI, go to the **Stacks** page and select **+ Add Stack**.
2. Name the stack "htpc" and select the "Web Editor" build method.
3. Copy the text in the docker-compose.yml contained in this repo and paste it into the web editor, then name your stack.
4. Configure the environment variables (they appear like this: ${value}) to match your setup and needs.
5. Optionally, configure LDAP and SMTP integration by uncommmenting their respective sections the .yml and configuring the environment variables.
6. Select "Deploy the stack" and wait for everything to deploy.

## Configuring our applications


    
# Finishing up
To finish, let's make sure our services are working correctly. 


