# What are we deploying?
A set of applications to assist in building and managing our network.
- [Nginx Proxy Manager](https://hub.docker.com/r/jc21/nginx-proxy-manager): This project comes as a pre-built docker image that enables you to easily forward to your websites running at home or otherwise, including free SSL, without having to know too much about Nginx or Letsencrypt.
- [Pi-hole](https://hub.docker.com/r/pihole/pihole):
- Fail2Ban:
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/): Protect your web servers from direct attack. From the moment an application is deployed, developers and IT spend time locking it down — configuring ACLs, rotating IP addresses, and using clunky solutions like GRE tunnels. There’s a simpler and more secure way to protect your applications and web servers from direct attacks: Cloudflare Tunnel. Ensure your server is safe, no matter where it’s running: public cloud, private cloud, Kubernetes cluster, or even a Mac mini under your TV.
# Rationale
Getting my networking stack was a pain for me when I was first getting started, especially when I was trying to wrap my head around the ins-and-outs of networking. I tried many solutions for networking and exposing my services, but none of the solutions I found met my requirements for simplicity of configuration and deployment. As someone working a full-time job and working through grad school, I needed a networking stack that could be set up simply in a fire-and-forget fashion. Enter Cloudflare Tunnels. These things revolutionized my lab, and I hope they'll do the same for you. 

# Things I plan on adding:

# Before we get started...

The next things are required for this setup to work.

## Creating our directories

## Setting up our .env and docker-compose.yml

## Configuring our applications
