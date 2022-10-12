# What are we deploying?
A set of applications used to monitor and manage applications deployed as Docker images.

- [Portainer](https://hub.docker.com/r/portainer/portainer-ce): Portainer Community Edition is a lightweight service delivery platform for containerized applications that can be used to manage Docker, Swarm, Kubernetes and ACI environments. It is designed to be as simple to deploy as it is to use. The application allows you to manage all your orchestrator resources (containers, images, volumes, networks and more) through a ‘smart’ GUI and/or an extensive API.
- [Grafana](https://hub.docker.com/r/grafana/grafana-oss): Grafana allows you to query, visualize, alert on and understand your metrics no matter where they are stored. This is how we will monitor our performance and resource usage across our applications and hardware.
- [cAdvisor](https://console.cloud.google.com/gcr/images/cadvisor/GLOBAL): cAdvisor (Container Advisor) provides container users an understanding of the resource usage and performance characteristics of their running containers. It is a running daemon that collects, aggregates, processes, and exports information about running containers. Specifically, for each container it keeps resource isolation parameters, historical resource usage, and histograms of complete historical resource usage. This data is exported by container and machine-wide.
- [Prometheus](https://hub.docker.com/r/prom/prometheus): Prometheus is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.
- [Node Exporter](https://quay.io/repository/prometheus/node-exporter?tab=tags&tag=latest): Prometheus exporter for machine metrics, written in Go with pluggable metric collectors. Used to collect resource usage information from Docker host machines.
- [InfluxDB](https://hub.docker.com/_/influxdb): InfluxDB is a time series database built from the ground up to handle high write and query loads. InfluxDB is meant to be used as a backing store for any use case involving large amounts of timestamped data, including DevOps monitoring, application metrics, IoT sensor data, and real-time analytics.
- [Watchtower](https://hub.docker.com/r/containrrr/watchtower): With watchtower you can update the running version of your containerized app simply by pushing a new image to the Docker Hub or your own image registry. Watchtower will pull down your new image, gracefully shut down your existing container and restart it with the same options that were used when it was deployed initially.
- [Heimdall](https://hub.docker.com/r/linuxserver/heimdall): Heimdall is a way to organise all those links to your most used web sites and web applications in a simple way. Simplicity is the key to Heimdall. Why not use it as your browser start page? It even has the ability to include a search bar using either Google, Bing or DuckDuckGo.
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
Directory setup for this stack is simple. We'll use '/management/' as our root directory. Create this directory with the command 'sudo mkdir /management/'. That's it! We're ready for the next parts of configuration.

## Installing and Configuring Portainer
Before we deploy our containers, we want to be able to manage them effectively. This will be done through Portainer. Portainer can stop, start, pause, create, and deploy our containers. To install it, insert the following command into the terminal: 'docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest'. This command will install Portainer and 
set it to broadcast the Web-UI over ports 8000 and 9443. To setup Portainer, enter "https://<dockerhostIPaddress>:9443" in your browser. You should see a page to create the initial admin user for Portainer. Create your username and password and login. 

In the Environment Wizard that appears after logging in, select 'Get Started' and connect to the local Docker envrionment. Next, I recommend you go to *Settings -> SSL Certificate* and enable "Force HTTPS only". This will help increase security down the line. We're done with Portainer config but we're not done using Portainer.

## Setting up our .env and docker-compose.yml
Copy

## Configuring our applications

