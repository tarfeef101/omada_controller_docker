# Dockerized Omada Controller
## Purpose
Right now, the Omada controller is shipped as:
- some windows executable (not my cup of tea)
- a Linux `.deb` (not used since it runs as part of the installation steps, which is a major PITA)
- a tarball (what we use here)

It also has some big and old dependencies, so Docker is a great way to isolate those from the rest of your system (and let's be honest, I didn't need an excuse to Dockerze anyway). You may be asking, why not use [this pre-existing repo](https://github.com/mbentley/docker-omada-controller) that's functional, supported, and seemingly well-made? 2 reasons. One, I find doing this fun. Two, that is VERY well done, but a big heavy for my tastes. A lot of decisions are made from you, if you don't trust any random person to maintain it (like me, master of abandoned repos) it's hard to pick up yourself, and I'm also a hipster who hates Ubuntu because it's popular, so I couldn't bring myself to use it. Plus, I maybe saved a couple MBs of image size, and who doesn't like that :laughing:? If none of those things sound like stuff you care about, you probably should use that tbh, it's a lot more user-friendly, this is more barebones (and in early development).

## Usage
Just run `docker-compose up -d` and you'll be off to the races. Make sure to create the volume directory `mkdir -p data/db` (the subdir must exist too, sadly). That, or edit the volume config to use named volumes and you don't have to care.

### Upgrading
Probably just `docker-compose down`, get/build the new image with a new URL/tag, and `docker-compose up -d` again. Have I tested this? No, no I have not. But it probably works.

## Limitations/Future Upgrades
- put this on docker hub
- tag things for new releases, and make an action to push images on new omada releases (might be hard to source, they release terribly)
  - paramaterize the URLs/tags like a smart person
- 5.0 of this controller should bring WAY newer deps, so that's important to get on top of once it's out
- maybe add nginx and certs if I care to do that?
- timeout of 30s is needed for graceful shutdowns, otherwise it will crash, and it is very fault-intolerant
