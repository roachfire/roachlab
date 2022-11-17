# roachlab
An ongoing project to create a secure and modular environment to host various services I find useful. Each different aspect of the server is meant to be deployed on its own virtual machine unless specified within the tutorials. These tutorials are aimed towards Proxmox users but most of the services and steps followed can be used on any platform--bare metal or otherwise.

# Rationale
I've been homelabbing and self-hosting for about a year now. I've grown a considerably large application stack and learned a lot of lessons along the way. The more applications I add, the more I realize how much of a pain spinning up and configuraing these services will be should my hardware or some other link in the chain fails. Thus I decided to finally get all of my configurations documented in an easily-accessible place. These configurations were created out of days of trial-and-error however. For some of these applications, several different tutorials were followed to get the configurations I used. This was because the documentation available either lacked some pieces of critical info or something didn't quite work with my particular setup and finding out how to fix the issue would have taken too long. 

This gave me the second goal of my project: make something that everyone can follow along with and fits as many use-cases as possible. With this goal in mind I aim to make this project as modular (hence the different directories for separate compenents and the use of docker-compose) and as comprehensive (hence the extensive documentation on setup) as possible. That way, anyone could follow along with and modify the configuration process. I also wanted to make sure that the project was able to setup a secure and comprehensive software stack with little need for configuration of outside applications/services. While the mistakes I made and the troubleshooting I did contributed greatly to my knowledge, not everyone has the time or the interest. 

I hope this "guide" helps :).

## Contents
These tutorials are meant to be followed in the order presented here. However, those who know what they are doing can forego the guides and simply use the configuration files I offer as they see fit.
- [MANAGEMENT](/management): A project to make managing/monitoring your self-hosted services and the servers hosting them simple and easy. WIP.
- [NETWORKING](/networking): A project to make managing various aspects of your HomeLab's network simple, secure, and painless.
- [HTPC](htpc/): A project to make self-hosting your entire home theater stack as simple as running one command (right now it takes a few though!).
