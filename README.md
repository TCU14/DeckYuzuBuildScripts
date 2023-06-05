# Deck Yuzu Build Scripts


Scripts for building Yuzu Mainline AppImages on the Steam Deck. Credit to [@mariok93](https://github.com/marioK93) for adapting
[yuzu's](https://github.com/yuzu-emu) scripts, without them the AppImages would not be useful outside of the container. While this was made for the deck, it should technically be distro agnostic.

## Usage

### Make sure you have at least 6-8gb of free space in the prefix location.

Clone the repository and execute BuildContainer.sh in a terminal that is in the same directory.

### BuildContainer.sh

Installs distrobox and podman at the desired prefix (Sources variable 'DISTROPOD' from renovationrc, default is /home/deck/.local. )

### BuildEnv

Executed by BuildContainer. This sets up the build environment and then builds an AppImage from [yuzu-mainline.](https://github.com/yuzu-emu/yuzu-mainline) By default
BuildContainer is supposed to delete the container when this is done (prompting you)

### renovationrc

Runtime configuration for the scripts
```
DISTROPOD - prefix for distrobox and podman
COMPFLAGS - CFLAGS to apply at build time
DESIREDREPO - Yuzu repository to clone (Coming soon: Specify local repository)
REPONAME - Name of repository
DECKRENOVATED - Boolean. Lowercase sensitive. DECKRENOVATED=true means you already
have distrobox and podman in your $PATH. false is default
```
