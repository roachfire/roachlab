# What are we deploying?
A set of applications used to monitor and manage applications deployed as Docker images.

- [Portainer](https://hub.docker.com/r/portainer/portainer-ce): Portainer Community Edition is a lightweight service delivery platform for containerized applications that can be used to manage Docker, Swarm, Kubernetes and ACI environments. It is designed to be as simple to deploy as it is to use. The application allows you to manage all your orchestrator resources (containers, images, volumes, networks and more) through a ‘smart’ GUI and/or an extensive API.
- [Homarr](https://github.com/ajnart/homarr#docker-installation): Homarr is a simple and lightweight homepage for your server, that helps you easily access all of your services in one place. It integrates with the services you use to display information on the homepage (E.g. Show upcoming Sonarr/Radarr releases).
- [Bookstack](https://hub.docker.com/r/linuxserver/bookstack): Bookstack is a free and open source Wiki designed for creating beautiful documentation. Featuring a simple, but powerful WYSIWYG editor it allows for teams to create detailed and useful documentation with ease.

# Before we get started...
I recommend you have the following in place before deploying this setup to make things a little easier:
- A service like [Tailscale](https://tailscale.com/) to allow you to remotely manage your services (and facilitate secure remote streaming). You can find installation documentation for your OS [here](https://tailscale.com/download/). 
- A Debian-based machine for your Docker host. I run my services on a Ubuntu Server host, so this tutorial was designed for that operating environment.
- A network firewall to ensure that only authorized devices are connecting to your services remotely.
- A certificate authority to allow you to create and distribute your own SSL certs for secure connections to your services. 

The next things are required for this setup to work.
- [Proxmox](https://proxmox.com/en/) to manage the machine that will be hosting our services. While you can run these applications on a bare metal OS, Proxmox affords the user much more granular control over resource allocation, networking, and other aspects of the machine that can reduce a lot of headaches when troubleshooting. Proxmox is what I use, so the tutorial will be tailored to a Proxmox VM host.
- At least one virtual machine. This goes without saying I hope.

## Creating our directories
Directory setup for this stack is simple. We'll use `/management/` as our root directory. Create this directory with the command 'sudo mkdir /management/'. That's it! We're ready for the next parts of configuration.

## Installing and Configuring Portainer
Before we deploy our containers, we want to be able to manage them effectively. This will be done through Portainer. Portainer can stop, start, pause, create, and deploy our containers. To install it, insert the following command into the terminal: `docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest`. This command will install Portainer and 
set it to broadcast the Web-UI over ports 8000 and 9443. To setup Portainer, enter "https://<dockerhostIPaddress>:9443" in your browser. You should see a page to create the initial admin user for Portainer. Create your username and password and login.

In the Environment Wizard that appears after logging in, select **Get Started** and connect to the local Docker envrionment. Next, I recommend you go to **Settings -> SSL Certificate** and enable **Force HTTPS only**. This will help increase security down the line. We're done with Portainer config but we're not done using Portainer.

## Deploying our Services
Typically, docker-compose.yml's are deployed through the docker-compose CLI command. However, Portainer has built-in support for deploying your Docker-Compose files. Portainer's built-in compose editor will point out errors in your .yaml/.yml and give you a simple interface to control administrative permissions. For now on, we'll be handling our deployments here.
1. In the Portainer UI, go to the **Stacks** page and select **+ Add Stack**.
2. Name the stack "management" and select the "Repository" build method.
3. In the **Repository URL** section paste "https://github.com/roachfire/roachlab". Edit **Compose path** to say "management/docker-compose.yml".
4. You can configure automatic updates if you want, but I really don't recommend this for repos you don't directly control.
5. For **Environment variables**, copy the text from the `.env` file in the management directory and paste it into a text file. Edit the file where the assigned variable values are "Changeme", using the comments as instructions.
6. Save the file as something easy to remember like "management.env". In the Portainer UI, select **Load variables from .env file** and select the saved `.env`.
7. Verify that everything looks correct and then select **Deploy the stack**. Everything should deploy smoothly from there.

## Configuring our applications
For Bookstack and Snipe-IT, configuration is going to be highly dependent on your use-case and goals. With this variance in mind, please refer to the excellent documentation for [Snipe-IT](https://snipe-it.readme.io/docs) and [Bookstack](https://www.bookstackapp.com/docs/). For the rest of our services, follow along below.
### 

