# What are we deploying?
A set of applications to assist in building and managing our network.
- [Nginx Proxy Manager](https://hub.docker.com/r/jc21/nginx-proxy-manager): This project comes as a pre-built docker image that enables you to easily forward to your websites running at home or otherwise, including free SSL, without having to know too much about Nginx or Letsencrypt.
- [Pi-hole](https://hub.docker.com/r/pihole/pihole): The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content, without installing any client-side software.
- [Fail2Ban](https://hub.docker.com/r/linuxserver/fail2ban): Fail2ban is a daemon to ban hosts that cause multiple authentication errors.
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/): Protect your web servers from direct attack. From the moment an application is deployed, developers and IT spend time locking it down — configuring ACLs, rotating IP addresses, and using clunky solutions like GRE tunnels. There’s a simpler and more secure way to protect your applications and web servers from direct attacks: Cloudflare Tunnel. Ensure your server is safe, no matter where it’s running: public cloud, private cloud, Kubernetes cluster, or even a Mac mini under your TV.
# Rationale
Getting my networking stack was a pain for me when I was first getting started, especially when I was trying to wrap my head around the ins-and-outs of networking. I tried many solutions for networking and exposing my services, but none of the solutions I found met my requirements for simplicity of configuration and deployment. As someone working a full-time job and working through grad school, I needed a networking stack that could be set up simply in a fire-and-forget fashion. Enter Cloudflare Tunnels. These things revolutionized my lab, and I hope they'll do the same for you. 
# Things I plan on adding:
- Integrating the Cloudflare container into the docker-compose file.
- Configuration guide for Fail2Ban (it's just a placeholder for now).
# Before we get started...
These are just some suggestions that might make things a little easier for you.
- A hypervisor like Proxmox to manage the machine that will be hosting our services. While you can run these applications on a bare metal OS, Proxmox affords the user much more granular control over resource allocation, networking, and other aspects of the machine that can reduce a lot of headaches when troubleshooting.
- An application like Portainer to help manage the containers you'll be creating. This tool is invaluable for troubleshooting and monitoring your containers.
- A service like Tailscale to allow you to remotely manage your services (and facilitate secure remote streaming). You can find installation documentation for your OS here. This is helpful for when Cloudflare or another stop in your network chain goes down.
- A Debian-based machine for your Docker host. I run my services on a Ubuntu Server host, so this tutorial was designed for that operating environment.
- A network firewall to secure things. Cloudflare handles most of the major security stuff for us, but just in case something gets through, you'll want to make sure everything is as isolated as possible.
The next things are required for this setup to work.
- Docker and docker-compose installed.
- A domain that uses Cloudflare for DNS. I purchased mine from [Porkbun](https://porkbun.com/). Documentation for how to connect domains to Cloudflare's DNS can be found [here](https://developers.cloudflare.com/fundamentals/get-started/setup/add-site/). The domain will cost you, but all of the stuff on the Cloudflare side of things will be free.
## Creating our directories
The first thing we'll need to do is create directories for some of our containers to store their data. `sudo mkdir /networking/` will take care of this for us. Since this stack is simple, this is the only directory we need to create.
## Setting up our .env and docker-compose.yml
`CD` into the directory you just created and use `sudo nano docker-compose.yml` to create our compose file. As mentioned before, the simplicity of this setup means we don't have to setup much here. Save the file and you should be good to go.. Now, we need to create our .env file. `sudo nano .env` will take care of this. Change the values that need be changed (indicated by the "Changeme") and save the file. Now we can deploy everything with a simple `docker-compose up -d`. 
## Configuring our applications
