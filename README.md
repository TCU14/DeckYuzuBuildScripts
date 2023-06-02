# DeckYuzuBuildScripts (STILL IN WRITING. NOT YET FUNCTIONAL AS INTENDED)


Scripts for building Yuzu Mainline AppImages on the Steam Deck. Credit to [@MarioROA](https://github.com/MarioROA) for adapting
[yuzu's](https://github.com/yuzu-emu) scripts, without them the AppImages would not be useful outside of the container.

## Usage

Clone the repository and execute BuildContainer.sh in a terminal that is in the same directory.

### BuildContainer.sh

Installs distrobox and podman at the desired prefix (Sources variable 'DISTROPOD' from renovationrc, default is /home/deck/.local. )

### BuildEnv

Executed by BuildContainer. This sets up the build environment and then builds an AppImage from [yuzu-mainline.](https://github.com/yuzu-emu/yuzu-mainline) by default
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
