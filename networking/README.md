# What are we deploying?
A set of applications to assist in building and managing our network. This combination of services will intelligently handle simple local access and secure remote access for all of your selfhosted applications, no port-forwarding or firewall configuration required.
- [Nginx Proxy Manager](https://hub.docker.com/r/jc21/nginx-proxy-manager): This project comes as a pre-built docker image that enables you to easily forward to your websites running at home or otherwise, including free SSL, without having to know too much about Nginx or Letsencrypt.
- [Pi-hole](https://hub.docker.com/r/pihole/pihole): The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content, without installing any client-side software.
- [Fail2Ban](https://hub.docker.com/r/linuxserver/fail2ban): Fail2ban is a daemon to ban hosts that cause multiple authentication errors.
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/): Protect your web servers from direct attack. From the moment an application is deployed, developers and IT spend time locking it down — configuring ACLs, rotating IP addresses, and using clunky solutions like GRE tunnels. There’s a simpler and more secure way to protect your applications and web servers from direct attacks: Cloudflare Tunnel. Ensure your server is safe, no matter where it’s running: public cloud, private cloud, Kubernetes cluster, or even a Mac mini under your TV.
# Rationale
Getting my networking stack was a pain for me when I was first getting started, especially when I was trying to wrap my head around the ins-and-outs of networking. I tried many solutions for networking and exposing my services, but none of the solutions I found met my requirements for simplicity of configuration and deployment. As someone working a full-time job and going through grad school, I needed a networking stack that could be set up simply in a fire-and-forget fashion. Enter Cloudflare Tunnels. These things revolutionized my lab, and I hope they'll do the same for you. 
# Things I plan on adding:
- Integrating the Cloudflare container into the docker-compose file.
- ~Configuration guide for Fail2Ban (it's just a placeholder for now).~
- A tutorial on setting up failover for NGINX, Pi-hole, and the Cloudflare tunnel.
# Before we get started...
These are just some suggestions that might make things a little easier for you.
- A static IP address set for the host(s) running PiHole and Nginx Proxy Manager.
- A hypervisor like [Proxmox](https://www.proxmox.com/en/) to manage the machine that will be hosting our services. While you can run these applications on a bare metal OS, Proxmox affords the user much more granular control over resource allocation, networking, and other aspects of the machine that can reduce a lot of headaches when troubleshooting.
- A password manager to securely manage passwords for your services. I recommend [Bitwarden](https://bitwarden.com/)
- A TOTP application to facilitate generating access codes to your services that are compatible with it.
- An application like [Portainer](https://www.portainer.io/) to help manage the containers you'll be creating. This tool is invaluable for troubleshooting and monitoring your containers.
- A service like Tailscale to allow you to remotely manage your services (and facilitate secure remote streaming). You can find installation documentation for your OS here. This is helpful for when Cloudflare or another stop in your network chain goes down.
- A Debian-based machine for your Docker host. I run my services on an Ubuntu Server host, so this tutorial was designed for that operating environment.
- A network firewall to secure things. Cloudflare handles most of the major security stuff for us, but just in case something gets through, you'll want to make sure everything is as isolated as possible.
The next things are required for this setup to work.
- Knowledge of firewalls, port mappings, and network security.
- [Docker](https://docs.docker.com/desktop/install/linux-install/) and [docker-compose](https://docs.docker.com/compose/install/linux/#install-using-the-repository) installed on your host machine.
- A domain that uses Cloudflare for DNS. I purchased mine from [Porkbun](https://porkbun.com/). Documentation for how to connect domains to Cloudflare's DNS can be found [here](https://developers.cloudflare.com/fundamentals/get-started/setup/add-site/). The domain will cost you, but all of the stuff on the Cloudflare side of things will be free.
- Disabling systemd-resolved as it conflicts with Pi-hole over port 53. This can be done with the commands `sudo systemctl disable systemd-resolved.service` and `sudo systemctl stop systemd-resolved`. Next, you must edit your resolv.conf to add a replacement nameserver, since you just disabled the internal one: `sudo nano /etc/resolv.conf` then comment out the `nameserver` line. Add another line that says `nameserver 8.8.8.8` or any other DNS server you'd like to use. Save and exit the file.
# Let's begin!
## Creating our directories
The first thing we'll need to do is create directories for some of our containers to store their data. `sudo mkdir /networking/` will take care of this for us. Since this stack is simple, this is the only directory we need to create.
## Setting up our .env and docker-compose.yml
`CD` into the directory you just created and use `sudo nano docker-compose.yml` to create our compose file. As mentioned before, the simplicity of this setup means we don't have to setup much here. Save the file and you should be good to go.. Now, we need to create our .env file. `sudo nano .env` will take care of this. Change the values that need be changed (indicated by the "Changeme") and save the file. Now we can deploy everything with a simple `docker-compose up -d`. 
## Configuring our applications
If everything installed properly, we should see our three containers running when we run the command `docker ps`.
### Nginx Proxy Manager
This container can be accessed at http://dockerhostipaddress:81. Upon entering the WebUI, you'll be presented with a page to create an admin account. Walk through the setup process and you'll be presented with the Nginx Proxy Manager dashboard. The first thing we're going to do is create our SSL cert. To make things simple, we're going to use a wildcard cert that will apply to all of our subdomains.
#### Creating our SSL certificate
1. Go to the **SSL Certificates** page. 
2. Click **Add SSL Certificate**. Select **Let's Encrypt**.
3. In the configuration dialogue, enter "*.your.domain", enter your email address, and toggle both of the switches at the bottom of the dialogue.
4. Select **Cloudflare** as your DNS provider and head to [this page](https://dash.cloudflare.com/profile/api-tokens) to get your API key. If you haven't generated one yet, click **Create Token**. Select **Edit Zone DNS** as your template. Select your domain for **Include -> Specific Zone -> Select...** and click **Continue to summary**. Then click **Create token**. The next screen will give you your API Token. Copy it and paste it after the "=" in the **Credentials File Content** box back in Nginx Proxy Manager. Then click **Save**.
#### Adding our services to NGINX Proxy Manager
1. Now we'll need to add proxy hosts to NPM. Select **Dashboard** in NGINX Proxy Manager and click **Add Proxy Host**.
2. We'll start with one for NGINX Proxy Manager. Enter "nginx.your.domain" in the **Domain Names** box. For scheme, select `http`. Enter the IP address or hostname (I recommend the hostname so you don't have to worry about changing IP addresses) of your server in the next box, followed by "81" in the **Forward Port** box. Toggle the **Cache Assets** and **Block Common Exploits** settings.
3.  Now, we can add our SSL cert. Click on the **SSL** tab and select your new wildcard certificate from the **SSL Certificate** dropdown. Turn on all of the toggles and then click **Save**. Repeat this process for all services you self-host, even those that you don't wish to expose to the web. Note that some services will use `https` instead of `http` as their scheme.
### Pi-hole
This container can be accessed at http://dockerhostipaddress:82/admin. Upon entering the address, you'll be presented with the login screen.
1. Enter the password you added to the `.env` file to access the UI. Pi-hole is preconfigured with a blocklist and pretty much every setting you'll need, but feel free to add other blocklists and mess around with the settings when we're finished here.
2. Expand **Local DNS** in the sidebar and select **DNS records**. You'll be taken to a page where you can add local DNS redirect records. Add all of the services you self-host, including those that you don't want exposed to the web, entering "<servicename>.your.domain" in the **Domain:** box and the IP address of the server hosting your NGINX Proxy Manager instance in the **IP Address:** box.
3. Once you're done there, you'll need to access your router's admin settings and set the IP address of the server running Pi-hole as your DNS server. Or you can set the Pi-hole host as your DNS server on a device-by-device basis. I recommend deploying a second instance of Pi-hole to serve as a backup in case your main instance fails.
### Fail2Ban
Fail2Ban's setup is fairly involved and I still haven't fully wrapped my head around it. However, DB Tech on YouTube has a great tutorial for setting up Fail2Ban to watch your containers and ban IPs through Cloudflare that can be found [here](https://www.youtube.com/watch?v=Ha8NIAOsNvo).
### Cloudflare tunnel
Getting the tunnel started is fairly simple.
#### Creating the tunnel
1. Go to the [Cloudflare Tunnels page](https://dash.cloudflare.com/?to=/:account/:zone/traffic/argo-tunnel), then click **Create a tunnel**. Name it something descriptive, then click **Save tunnel**.
2. On the next page, select **Docker** as the operating system. Then, copy the command that appears in the **Install and run a connector** section.
3. On your docker host, paste and run the command in the command line. This will install and deploy our container, automatically connecting it to our Cloudflare account. Then, click *Next**.
4. In the **Public Hostnames** section, enter "*.your.domain" to create wildcard domain entry. Then, enter the hostname or IP address of your NGINX Proxy Manager hsot, appending ":443" to the end of the address. Select `HTTPS` as the Service Type. Then click **Save hostname**. This will make Cloudflare forward traffic from NGINX Proxy Manager to our DNS.
#### Adding DNS records for our subdomains to Cloudflare
1. Leaving the Cloudflare Tunnels tab open, go to your [Cloudflare Dashboard](https://dash.cloudflare.com/login) and select **DNS** from the sidebar.
2. Click **+ Add record**. Select `CNAME` for the **Type** and enter the name of the first subdomain you'd like to be accessible online.
3. Return to the Cloudflare Tunnels tab and copy the code under the tunnel name. Return to the DNS tab and paste that code into the **Target** textbox. Then click **Save**. If everything was configured correctly, you should be able to access your service at "service.your.domain".
#### Securing your hosted services
If you're like me and decided to place all of your selfhosted services in your Cloudflare tunnel (even those that are used for management), you may want to place some extra security in front of them. Thankfully, Cloudflare has an excellent security solution available for free.
1. Open the Cloudflare Tunnels tab and click **Applications** in the sidebar.
2. Click **Add an application**, then select **Self-hosted**. Enter a name, configure a session duration, then fill out the rest of the fields with the application's information. Click **Next** once done.
3. On the next page, you'll configure your access policies. Give the policy a name.
4. To make things simple, I configure one rule for each service I want secured. For the **Selector**, I choose emails, then enter my primary email address for **Value**. This makes it to where every time you access that site from a new browser session from a device not on your local network, you'll be prompted to enter your email address to recieve an access code. Only the email addresses you designate will be able to recieve a code.
# Closing thoughts
What we've configured here is local and external access for your domains. If you try to access your service from your local network, Pi-hole will provide a direct connection to the service. However, if you try to access it from an external network, Cloudflare will intercept the traffic and force you to authenticate. Cloudflare offers a wealth of other options to improve the security of your services (but what we've configured here is a pretty safe baseline), so I recommend reading through their extensive documentation on the topic. In addition, I recommend configuring passwords and 2FA within each of the services you host for extra security, alongisde a local firewall to control access on your local network.
