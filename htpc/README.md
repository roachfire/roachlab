# What are we deploying?
A fully-featured home theater application stack with services to automatically download selected tv, movies, music, and subtitles and stream them from a Plex media server.
- [Transmission + OpenVPN](https://github.com/haugene/docker-transmission-openvpn): This container contains OpenVPN and Transmission with a configuration where Transmission is running only when OpenVPN has an active tunnel. It has built in support for many popular VPN providers to make the setup easier.
- [Prowlarr](https://hub.docker.com/r/linuxserver/prowlarr): Prowlarr is a indexer manager/proxy built on the popular arr .net/reactjs base stack to integrate with your various PVR apps. Prowlarr supports both Torrent Trackers and Usenet Indexers. It integrates seamlessly with Sonarr, Radarr, Lidarr, and Readarr offering complete management of your indexers with no per app Indexer setup required (we do it all).
- [Sonarr](https://hub.docker.com/r/linuxserver/sonarr): Sonarr (formerly NZBdrone) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
- [Lidarr](https://hub.docker.com/r/linuxserver/lidarr): Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
- [Radarr](https://hub.docker.com/r/linuxserver/radarr): Radarr - A fork of Sonarr to work with movies à la Couchpotato.
- [Bazarr](https://hub.docker.com/r/linuxserver/bazarr): Bazarr is a companion application to Sonarr and Radarr. It can manage and download subtitles based on your requirements. You define your preferences by TV show or movie and Bazarr takes care of everything for you.
- [Plex-Server](https://hub.docker.com/r/plexinc/pms-docker): With our easy-to-install Plex Media Server software and your Plex apps, available on all your favorite phones, tablets, streaming devices, gaming consoles, and smart TVs, you can stream your video, music, and photo collections any time, anywhere, to any device.
- [nzbget](https://hub.docker.com/r/linuxserver/nzbget): Nzbget is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.
- [Overseerr](https://hub.docker.com/r/linuxserver/overseerr): Overseerr is a request management and media discovery tool built to work with your existing Plex ecosystem.
- [Readarr](https://hub.docker.com/r/linuxserver/readarr): Readarr is a ebook collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new books from your favorite authors and will interface with clients and indexers to grab, sort, and rename them. 
- [Calibre-Web](https://hub.docker.com/r/linuxserver/calibre-web): Calibre-web is a web app providing a clean interface for browsing, reading and downloading eBooks using an existing Calibre database. It is also possible to integrate google drive and edit metadata and your calibre library through the app itself.
- [Calibre](https://hub.docker.com/r/linuxserver/calibre): Calibre is a powerful and easy to use e-book manager. Users say it's outstanding and a must-have. It'll allow you to do nearly everything and it takes things a step beyond normal e-book software. It's also completely free and open source and great for both casual users and computer experts.
- [TubeSync](http://ghcr.io/meeb/tubesync): TubeSync is a PVR (personal video recorder) for YouTube. Or, like Sonarr but for YouTube (with a built-in download client). It is designed to synchronize channels and playlists from YouTube to local directories and update your media server once media is downloaded.

# Rationale
This project was originally a fork of a project by [sebgl](https://github.com/sebgl/htpc-download-box) but after following his tutorial I encountered some issues with deployment and noticed some documentation that could've been improved upon. Thus I feel the changes I have made and plan on making are significant enough to warrant creating my own repo. The goal of this project is to create a home theater software stack with the least amount of work required by the user while providing the flexibility to accomodate those who do wish to change things. I hope you can see this focus in some of the changes I have made to sebgl's original work. All of this is not to say that sebgl's work is bad, but for someone like me who doesn't have the time nor expertise to figure out some of the steps required on my own, I needed a better solution. I hope that this works well for people in my own shoes. Now, let's get on with the show.

# Things I plan on adding:
- A Tailscale docker container to facilate secure remote access to your services without opening any ports.
- A firewall configuration guide to lockdown access to your applications.
- ~~[Plex Requests](https://dediseedbox.com/wiki/knowledgebase/plex-requests/) to make it easier to add TV, movies, and music to Plex.~~ (Replaced with Overseerr)
- ~~[Ombi](https://hub.docker.com/r/linuxserver/ombi/) to further enhance the request experience for those sharing their Plex servers with large amounts of users.~~ (replaced with Overseerr)

# Before we get started...
These are some recommendations that might make things a little easier for you, but **are not required** as everyone has their own system and workflow for maintaining their services.
- The [nzb360 app](https://nzb360.com/) if you're on Android or [NZBClient](https://apps.apple.com/us/app/nzbclient-for-nzbget/id1178245637) if you're on iOS.
- A hypervisor like [Proxmox](https://proxmox.com/en/) to manage the machine that will be hosting our services. While you can run these applications on a bare metal OS, Proxmox affords the user much more granular control over resource allocation, networking, and other aspects of the machine that can reduce a lot of headaches when troubleshooting.
- An application like [Portainer](https://docs.portainer.io/start/install/server/docker/linux) to help manage the containers you'll be creating. This tool is invaluable for troubleshooting and monitoring your containers (in my opinion).
- A separate storage server (NAS). It is always a good idea to keep your systems separated by roles. You can do this by making either separate VMs for the storage server and the home theater stack, or by using separate physical machines. This way, if one machine goes down you're not losing access to all aspects of your system, especially if your storage server hosts more than just your movies and tv.
- A service like [Tailscale](https://tailscale.com/) to allow you to remotely manage your services (and facilitate secure remote streaming). You can find installation documentation for your OS [here](https://tailscale.com/download/). 
- [Plex Pass](https://www.plex.tv/plex-pass/). This is Plex's Premium service that gives you access to useful features like unlimited mobile clients, hardware acceleration (useful for HDR tonemapping and transcoding), etc. The pricing isn't all that bad either. 
- A decent graphics card or a [CPU that supports Intel Quicksync](https://www.edius.net/quicksync.html). If you're transcoding large streams with a lot of data per frame, you're going to want one of these things to help speed things up. If you're running a server-grade CPU with a lot of cores you can probably get around this limitation.
- A Debian-based machine for your Docker host. I run my services on a Ubuntu Server host, so this tutorial was designed for that operating environment.

The next things are required for this setup to work.

- A free Plex account.
- [Docker](https://docs.docker.com/engine/install/ubuntu/) and [Docker-Compose](https://docs.docker.com/compose/install/linux/) installed on your host system.
- A VPN service. I recommend Mullvad, PIA, or Nord for this particular setup, but most should work just fine with some tweaking.
- If you plan on using separate machines (virtual or physical) for your storage server and your docker host make sure that both have dedicated IP addresses so that they can always find each other in the event of a network or machine restart. Ensure they're on the same subnet/VLAN as well.
- Plenty of RAM and storage. RAM is useful for caching large streams and downloads while storage is going to be useful for... You know, storing your data!

# Let's begin!

## Creating our directories
The first thing you're going to want to do is create directories for our containers to store their data and to store media they download for us. For this stack, we'll need two. One for the ${ROOT} variable in our .env file and one for the ${SRVR} variable. Root is where *most* of our containers will store their configuration files and SRVR is where the media will be stored. 

Use `sudo mkdir -p htpcproject/container_data/config` to create our ${ROOT} directory.

User `sudo mkdir -p data/media/{books,tv,movies,music} data/downloads/{complete,incomplete,resume}` to create our ${SRVR} directory. Make sure you run this command wherever you plan on storing your downloads and media library. This command creats the below file structure:

```
data/
├── downloads/
│   ├── complete/
│   ├── incomplete/
│   └── resume/
└── media/
    ├── books/
    ├── movies/
    ├── music/
    └── tv/
```
This file allows our containers to hardlink files from the download directory to the media library directory. Otherwise, Sonarr, Radarr, Lidarr, and Readarr would copy files from the downloads directory to the media library, taking up double the space. 
 
## Creating our users and group
For security and organization's sake, we're going to give each of our services their own user account on the system. These commands will create the users we'll need:
```
sudo useradd plex && id plex
sudo useradd calibre-web && id calibre-web
sudo useradd calibre && id calibre
sudo useradd tubesync && id tubesync
sudo useradd overseerr && id overseerr
sudo useradd abc && id abc
```
Write down the UIDs spit out after each command runs. We'll be using these to configure our .env file.

Next, we're going to create a group called "mediaserver" to add our containers to. This will allow our directories to share permissions across multiple users. `sudo groupadd mediaserver && id mediaserver` will create the group and output it's ID. Write this down as well.

## Deploying our services

### Deployment through docker-compose
You can either copy and paste from the docker-compose.yml and .env files in this repo or you can download them directly. `cd` into your project directory and `sudo nano .env` to create the .env file. Once there, you'll need to copy and paste the text from my file. Change the values for `TZ`, `ROOT`, and `SRVR` to ones that fit your setup. Values for `TZ` can be found [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) and the `ROOT` and `SRVR` values will be the directories you created previously. You can change the `PUID` and `PGID` if you want, but it's not necessary. Save and close our .env with CTRL + X. Confirm that you wish to save changes and that you like the file name. 
Next, we need to set up our docker-compose.yml. `sudo nano docker-compose.yml` to create the file. Paste the text from my file into here. There's only a few things we'll need to change here. Scroll down to your `transmission`. Find the `environment` section. This is where you'll set up your VPN. Enter your provider's name, your username, and your password. I use Mullvad, so the values there are configured for a Mullvad user. If you have another provider, refer to the excellent documentation [here](https://haugene.github.io/docker-transmission-openvpn/supported-providers/) to configure the container for your provider. Then, go down to the `LOCAL_NETWORK` line. Enter the CIDR of your local network so that the Transmission container's web-UI can be accessed on your local network. That's it! Our services are ready to be deployed. Save and exit the docker-compose.yml and enter the command `docker-compose up -d`. Monitor the terminal to ensure that everything deploys properly. Once that's done, we can see the status of our containers with `docker ps`. Now, onto the application configuration

### Deployment through Portainer's "stacks" feature
Typically, docker-compose.yml's are deployed through the docker-compose CLI command. However, Portainer has built-in support for deploying your Docker-Compose files. Portainer's built-in compose editor will point out errors in your .yaml/.yml and give you a simple interface to control administrative permissions.
1. In the Portainer UI, go to the **Stacks** page and select **+ Add Stack**.
2. Name the stack "htpc" and select the "Web Editor" build method.
3. Copy the text in the docker-compose.yml contained in this repo and paste it into the web editor, then name your stack.
4. Scroll down to your `transmission`. Find the `environment` section. This is where you'll set up your VPN. Enter your provider's name, your username, and your password. Refer to the excellent documentation [here](https://haugene.github.io/docker-transmission-openvpn/supported-providers/) to configure the container for your VPN provider.
5. Then, go down to the `LOCAL_NETWORK` line. Enter the CIDR of your local network so that the Transmission container's web-UI can be accessed on your local network. That's it! Our services are ready to be deployed.
6. Select "Deploy the stack" and wait for everything to deploy.

## Configuring our applications

### Prowlarr
The first thing I like to set up is my indexers. Go to the Prowlarr WebUI by entering "dockerhostIPaddress:9696" into your browser. Next we want to do is go to `Settings` -> `General` and create a username and password. Restart as prompted. Next, we want to the `Indexers` section at the top of the left pane. Click `Add Indexer` and add the indexers you want to use. If you don't have any paid indexers, sort by `en-US` for language and `Public` for privacy. Now we need to configure the rest of our applications.

### Plex 
**A note on Plex and VLANS: make sure that you access your Plex server from a device on the same VLAN for initial setup, as Plex does not allow connections from other VLAN by default. For example: if your Plex is on 192.168.20.0/24, it will not accept connections from 192.168.30.0/24**.
Enter "<dockerhostIPaddress>:32400/web" into your browser. You should see the Plex Media Server setup page show up. You'll be prompted to name your server and optionally configure the server for remote access outside of your network. I personally don't configure this setting as I use Tailscale to safely connect to my services from external networks. Next we need to configure Plex's library files. For Movies, make the library path `/data/movies` and for TV make it `/data/tv`. Your music library should be added to `/data/music`. The next thing I recommend configuring in Plex is going to `Settings` -> `Library`, and enabling the "Scan my library automatically" setting and the "Run a partial scan when changes are detected" settings.

### Sonarr
Now that we have our indexers and Plex set up, lets configure Sonarr. Sonarr can be accessed at "<dockerhostIPaddress>:8989"
- Go to `Settings` -> `General` and create a username and password. Restart the application when prompted.
- Once you refresh the page and login, navigate back to `General` if needed and copy the API Key.
- Return to the Prowlarr webUI and go to `Settings` -> `Apps`. 
- Click on `+` and then `Sonarr`.
- Set sync level to "Full Sync", add your Prowlarr server's address, your Sonarr server's address, and paste your API Key.
- Click save and your setup should be done. Your indexers should automatically show up in the `Settings` -> `Indexers` section of the app. 
The next thing we need to do is to tell Sonarr to use Transmission.
- Click `Download Clients`.
- Click the `+` icon and click on `Transmission`.
- Give Transmission a name and configure the rest of the settings as needed for your setup. I recommend making sure that "Remove Completed" is checked.
- You will most likely need to map the directory that Sonarr sees to the directory that Transmission sees internally using a "Remote Path". The internal Transmission path is `/torrents/complete` whereas the Sonarr path is `/data/torrents/complete`.
Finally, we can connect Plex to Sonnar.
- Go to `Connect` and click the `+` button. 
- Click `Plex Media Server`and configure it as needed for your setup. Click `Authenticate with Plex.tv` and login with your Plex account.
That's it! Sonarr is ready to go.

### Radarr, Readarr, and Lidarr
To configure Radarr, Readarr, and Lidarr, simply follow all of the steps above as the applications are virtually the same. They can be found at "dockerhostIPaddress:7878","dockerhostIPaddress:8787", and "dockerhostIPaddress:8686", respectively. Remember that each application should use the folder in the `/data/media` directory that corresponds with the media they collect as the root.

### Overseerr
Let's get Overseerr set up so our users can start requesting thing.
- Head over to "<dockerhostIPaddress>:5055" and login to your Plex account.
- Click "Settings" in the sidebar and configure the General settings to suit your needs. Make sure the Application URL matches the URL you configure in your reverse proxy if you use one.
- Configure the "Users" page to fit your needs.
- On the "Plex" tab, select your server from the dropdown, then select the libraries you want to sync.
- On the "Services" tab, add the info for your Radarr and Sonarr settings to match what you configured earlier.
- Configure the other tabs as you wish, but I didn't mess with these.
- Overseerr will import users from those you've authorized for access to your Plex server. If you want to allow people to make requests to Sonarr and Radarr, have them make a Plex account and invite them to your server.
    
# Finishing up
To finish, let's make sure our services are working correctly. 
- Open your Transmission webUI at "<dockerhostIPaddress>:9091", then open Sonarr, Radarr, and Plex. 
- Login to whichever app you want to test first and click `Add New`.
- Search for a show you like and click on it. Make sure that the media is being stored in the proper root folder for the service.
- Select the monitor settings you want and your preferred quality profile (for testing purposes, I recommend leaving the quality profile at "Any". 
- Check `Start search for missing <mediatype>` and click `Add <medianame>`. 
- Go back to the Transmission webUI and see if Torrents for your media start to appear.
- Wait for the Torrents to finish and see if the media starts to show up in your Plex Media Server. 
- Repeat the test for the rest of your applications.
- Mess around with the quality profiles to suit your needs.
If everything is working properly, your htpc setup should done and ready to go.
