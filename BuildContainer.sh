#!/bin/bash
source ./rennovationrc

#setup distrobox if not already, will require restarting terminal session
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix $DISTROPOD
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/extras/install-podman | sh -s -- --prefix $DISTROPOD
export PATH=$DISTROPOD/bin:$PATH >> ~/.bashrc
export PATH=$DISTROPOD/podman/bin:$PATH >> ~/.bashrc
source ~/.bashrc
chmod a+x ./BuildEnv.sh
#create archlinux container in distrobox
distrobox create -i archlinux --name ContainerEnv
distrobox enter ContainerEnv -- sh -c ./BuildEnv.sh
wait
echo "Cleaning up. Press Enter when prompted"

distrobox stop ContainerEnv
distrobox rm ContainerEnv

echo "All done."
