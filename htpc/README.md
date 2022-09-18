# Things I plan on Adding:
- A Tailscale docker container to facilate secure remove access to your services without opening any ports.
- A firewall configuration guide to lockdown access to your applications.
- A cloudflared docker container to facilitate secure remote access on devices that don't have Tailscale installed.
- A music service in the same vein as Sonarr and Radarr.
- Adapting the project to be aimed primarily at NAS users.
# Rationale
This project was originally a fork of a project by [sebgl](https://github.com/sebgl/htpc-download-box) but after following his tutorial I encountered some issues with deployment and noticed some documentation that could've been improved upon. Originally, this was meant to be a fork, but I feel the changes I have made and plan on making are significant enough to warrant creating my own repo. The goal of this project is to create a home theater software stack with the least amount of work required by the user while providing the flexibility to accomodate those who do wish to change things. I hope you can see this focus in some of the changes I have made to sebgl's original work. All of this is not to say that sebgl's work is bad, but for someone like me who doesn't have the time nor expertise to figure out some of the steps required on my own, I needed a better solution. I hope that this works well for people in my own shoes. Now, let's get on with the show.

# What are we deploying?
- [Heimdall](https://hub.docker.com/r/linuxserver/heimdall): Heimdall is a way to organise all those links to your most used web sites and web applications in a simple way. Simplicity is the key to Heimdall. Why not use it as your browser start page? It even has the ability to include a search bar using either Google, Bing or DuckDuckGo.
- [Transmission + OpenVPN](https://github.com/haugene/docker-transmission-openvpn): This container contains OpenVPN and Transmission with a configuration where Transmission is running only when OpenVPN has an active tunnel. It has built in support for many popular VPN providers to make the setup easier.
- [Jackett](https://hub.docker.com/r/linuxserver/jackett): Jackett works as a proxy server: it translates queries from apps (Sonarr, SickRage, CouchPotato, Mylar, etc) into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.
- [Sonarr](https://hub.docker.com/r/linuxserver/sonarr): Sonarr (formerly NZBdrone) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
- [Radarr](https://hub.docker.com/r/linuxserver/radarr): Radarr - A fork of Sonarr to work with movies à la Couchpotato.
- [Plex-Server](https://hub.docker.com/r/plexinc/pms-docker): With our easy-to-install Plex Media Server software and your Plex apps, available on all your favorite phones, tablets, streaming devices, gaming consoles, and smart TVs, you can stream your video, music, and photo collections any time, anywhere, to any device.
- [Bazarr](https://hub.docker.com/r/linuxserver/bazarr): Bazarr is a companion application to Sonarr and Radarr. It can manage and download subtitles based on your requirements. You define your preferences by TV show or movie and Bazarr takes care of everything for you.
- [nzbget](https://hub.docker.com/r/linuxserver/nzbget): Nzbget is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.

# Before we get started...
These are some recommendations that might make things a little easier for you, but **are not required** as everyone has their own system and workflow for maintaining their services.

- The nzb360 app
- A hypervisor like [Proxmox](https://proxmox.com/en/) to manage the machine that will be hosting our services. While you can run these applications on a bare metal OS, Proxmox affords the user much more granular control over resource allocation, networking, and other aspects of the machine that can reduce a lot of headaches when troubleshooting.
- An application like [Portainer](https://docs.portainer.io/start/install/server/docker/linux) to help manage the containers you'll be creating. This tool is invaluable for troubleshooting and monitoring your containers.
- A separate storage server. It is always a good idea to keep your systems separated by roles. You can do this by making either separate VMs for the storage server and the home theater stack, or by using separate physical machines. This way, if one machine goes down you're not losing access to all aspects of your system, especially if your storage server hosts more than just your movies and tv.
- A service like [Tailscale](https://tailscale.com/) to allow you to remotely manage your services (and facilitate secure remote streaming). You can find installation documentation for your OS [here](https://tailscale.com/download/). 
- [Plex Pass](https://www.plex.tv/plex-pass/). This is Plex's Premium service that gives you access to useful features like unlimited mobile clients, hardware acceleration (useful for HDR tonemapping and transcoding), etc. The pricing isn't all that bad either. 
- A decent graphics card or a [CPU that supports Intel Quicksync](https://www.edius.net/quicksync.html). If you're transcoding large streams with a lot of data per frame, you're going to want one of these things to help speed things up. 
- A Debian-based machine for your Docker host. I run my services on a Ubuntu Server host, so this tutorial was designed for that operating environment.

The next things are required for this setup to work.
- A free Plex account.
- Docker and Docker-Compose installed on your host system.
- A VPN service. I recommend Mullvad, PIA, or Nord for this particular setup, but most should work just fine with some tweaking.
- If you plan on using separate machines (virtual or physical) for your storage server and your docker host make sure that both have dedicated IP addresses so that they can always find each other in the event of a network or machine restart.
- Plenty of RAM and storage. RAM is useful for caching large streams and downloads while storage is going to be useful for... You know, storing your data!
# Let's begin!
## Creating our directories
The first thing you're going to want to do is create directories for our containers to store their data and to store media they download for us. For this stack, we'll need two. One for the {ROOT} variable in our .env file and one for the {SRVR} variable. Root is where *most* of our containers will store their configuration files and SRVR is where the media will be stored. So, make a directory on your docker host and make one on your storage host and name them whatever you wish. This can be accomplished with `sudo mkdir /your/directory/here`. Use this same commmand to create a working directory for our project (something like /htpcproject/).

## Setting up our .env and docker-compose.yml
You can either copy and paste from the docker-compose.yml and .env files in this repo or you can download them directly. `cd` into your project directory and `sudo nano .env` to create the .env file. Once there, you'll need to copy and paste the text from my file. Change the values for `TZ`, `ROOT`, and `SRVR` to ones that fit your setup. Values for `TZ` can be found [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) and the `ROOT` and `SRVR` values will be the directories you created previously. You can change the `PUID` and `PGID` if you want, but it's not necessary. Save and close our .env with CTRL + X. Confirm that you wish to save changes and that you like the file name. 

Next, we need to set up our docker-compose.yml. `sudo nano docker-compose.yml` to create the file. Paste the text from my file into here. There's only a few things we'll need to change here. Scroll down to your `transmission`. Find the `environment` section. This is where you'll set up your VPN. Enter your provider's name, your username, and your password. I use Mullvad, so the values there are configured for a Mullvad user. If you have another provider, refer to the excellent documentation [here](https://haugene.github.io/docker-transmission-openvpn/supported-providers/) to configure the container for your provider. Then, go down to the `LOCAL_NETWORK` line. Enter the CIDR of your local network so that the Transmission container's web-UI can be accessed on your local network. That's it! Our services are ready to be deployed. Save and exit the docker-compose.yml and enter the command `docker-compose up -d`. Monitor the terminal to ensure that everything deploys properly. Once that's done, we can see the status of our containers with `docker ps`. Now, onto the application configuration.

## Configuring our applications
### Jackett
The first thing I like to set up is my indexers. Go to the Jackett WebUI by entering "dockerhostIPaddress:9117" into your browser. You shouldn't have to configure anything in the Jackett Configuration section at the bottom of the page, but you can if you want to. I don't configure a password because this service is only accessible via Tailscale in my configuration. To add your indexers, go to the searchbar and search for the ones you want. If you don't know where to start, I typically filter for public and en-US indexers. The ones I currently use are 1337x, Anime Tosho, AnimeClipse, The Pirate Bay, and YTS. These have been working fine for me so far.
### Plex 
**A note on Plex and VLANS: make sure that you access your Plex server from a device on the same VLAN for initial setup, as Plex does not allow connections from other VLAN by default. For example: if your Plex is on 192.168.20.0/24, it will not accept connections from 192.168.30.0/24**.
Next we need to configure Plex's library files. Enter "dockerhostIPaddress:32400/web" into your browser. You should see the Plex Media Server page show up. You'll be prompted to login, then to configure your libraries. For Movies, make the library path `/data/movies` and for TV make it `/data/tv`. You'll also be prompted to name your server and optionally configure the server for remote access outside of your network. I personally don't configure this setting as I use Tailscale to safely connect to my services from external networks. 
The next thing I recommend configuring in Plex is going to `Settings`, `Library`, and enabling the "Scan my library automatically" setting and the "Run a partial scan when changes are detected" settings.
### Sonarr
Now that we have our indexers and Plex set up, lets configure Sonarr. I like to add my indexers to the service first.
- Enter "dockerhostIPaddress:8989" in your browser.
- Go to `Settings` and click the `+` icon. 
- Select `Torznab` from the indexer types.
- Give your indexer a name and go back to the Jackett webUI.
- Find the indexer you want to add first and click `Copy Torznab Feed`. Paste this into the URL section of the Sonarr Add Indexer window. 
- Then, return to the Jackett webUI and copy the API Key at the top of the window. 
- Paste the API Key into the corresponding textbox in the Sonarr Add Indexer window.
- Repeat these steps for the rest of your indexers.
The next thing we need to do is to tell Sonarr to use Transmission.
- Click `Download Clients`.
- Click the `+` icon and click on `Transmission`.
- Give Transmission a name and configure the rest of the settings as needed for your setup. I recommend making sure that "Remove Completed" is checked.
Finally, we can connect Plex to Sonnar.
- Go to `Connect` and click the `+` button. 
- Click `Plex Media Server`and configure it as needed for your setup. Click `Authenticate with Plex.tv` and login with your Plex account.
That's it! Sonarr is ready to go.
### Radarr
To configure Radarr, simply follow all of the steps above as the applications are virtually the same. It can be found at "dockerhostIPaddress:7878". 
### About Bazarr and nzbget
I personally don't use these services, so I'll refer you back to the sebgl project linked in the first section for a setup guide.
# Finishing up
To finish, let's make sure our services are working correctly. 
- Open your Transmission webUI at "dockerhostIPaddress:9091", then open Sonarr, Radarr, and Plex. 
- Login to whichever app you want to test first and click `Add New`.
- Search for a show you like and click on it. Make sure that the Root Folder shows `/tv/<showname>.
- Select the monitor settings you want and your preferred quality profile (for testing purposes, I recommend leaving the quality profile at "Any". 
- Check `Start search for missing episodes` and click `Add <seriesname>`. 
- Go back to the Transmission webUI and see if Torrents for your series start to appear.
- Wait for the Torrents to finish and see if the episodes start to show up in your Plex Media Server. 
- Repeat the test for Radarr.
If everything is working properly, your htpc setup should done and ready to go. 
