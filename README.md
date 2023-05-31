# DeckYuzuBuildScripts (STILL IN WRITING. NOT YET FUNCTIONAL AS INTENDED)


Scripts for building Yuzu Mainline AppImages on the Steam Deck. Credit to [@MarioROA](https://github.com/MarioROA) for adapting
[yuzu's](https://github.com/yuzu-emu) scripts, without them the AppImages would not be useful outside of the container.

## Usage

Clone the repository and execute BuildContainer.sh in a terminal 

### BuildContainer.sh
Installs distrobox and podman at the desired prefix (Sources variable 'DISTROPOD' from rennovationrc, default is /home/deck/.local. )

### BuildEnv
Executed by BuildContainer. This sets up the build environment and then builds an AppImage from [yuzu-mainline.](https://github.com/yuzu-emu/yuzu-mainline) 
BuildContainer is supposed to delete the container when this is done (prompting you) but it will also delete the source code for 
mainline. Keep in mind podman cached an archlinux image 
