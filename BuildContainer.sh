#!/bin/bash

passTorch () {
source $HOME/.bashrc
chmod a+x ./BuildEnv.sh
#create archlinux container in distrobox

distrobox create -i docker.io/archlinux --name ContainerEnv
wait
distrobox enter ContainerEnv -- sh -c ./BuildEnv.sh
wait
echo "Cleaning up. You will be prompted"
sleep 3
distrobox stop ContainerEnv
wait
distrobox rm ContainerEnv
podman image rm archlinux
mv $REPONAME/build/yuzu--*.AppImage ./
wait
echo "All done."
exit 0
}
source $HOME/.bashrc
source ./renovationrc
while read -p 'DO YOU AGREE NOT TO ASK YUZU DEVELOPERS FOR SUPPORT WITH YOUR CUSTOM APPIMAGES? (y/N) ' confirm
do
  case "$confirm" in
    n|N) continue;;
    y|Y) break;;
    *)   continue;;
  esac
done
#setup distrobox if not already installed
if [ "$DECKRENOVATED" != 'true' ]; then
      curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix $DISTROPOD
      curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/extras/install-podman | sh -s -- --prefix $DISTROPOD
      echo "export PATH=$DISTROPOD/bin:$DISTROPOD/podman/bin:$PATH" >> $HOME/.bashrc
      wait
      sed -n 's/false/true/gp' ./renovationrc
      else
      echo "distrobox and podman already installed, moving on..."
fi
      passTorch
