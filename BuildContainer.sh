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
chmod +x ./yuzu--*.AppImage
echo "Pruning AppImage"
wait
./yuzu--*.AppImage --appimage-extract
wait $!
mkdir ./LibDir
wait
mv squashfs-root/usr/lib/{libaom.so.3,libasyncns.so.0,libatk-1.0.so.0,libatk-bridge-2.0.so.0,libatspi.so.0,libavcodec.so.60,libavdevice.so.60,libavfilter.so.9,libavformat.so.60,libavutil.so.58,libblkid.so.1,libbz2.so.1.0,libcairo-gobject.so.2,libcairo.so.2,libcrypto.so.3,libdbus-1.so.3,libdw.so.1,libelf.so.1,libepoxy.so.0,libffi.so.8,libFLAC.so.12,libgcrypt.so.20,libgdk-3.so.0,libgdk_pixbuf-2.0.so.0,libgio-2.0.so.0,libglib-2.0.so.0,libgmodule-2.0.so.0,libgobject-2.0.so.0,libgstapp-1.0.so.0,libgstaudio-1.0.so.0,libgstbase-1.0.so.0,libgstpbutils-1.0.so.0,libgstreamer-1.0.so.0,libgsttag-1.0.so.0,libgstvideo-1.0.so.0,libgtk-3.so.0,libhwy.so.1,libicudata.so.72,libicui18n.so.72,libicuuc.so.72,libjpeg.so.8,libjxl.so.0.8,libjxl_threads.so.0.8,liblz4.so.1,liblzma.so.5,libmount.so.1,libmpg123.so.0,libogg.so.0,libopenmpt.so.0,liborc-0.4.so.0,libpcre2-16.so.0,libpcre2-8.so.0,libpixman-1.so.0,libpng16.so.16,libpostproc.so.57,libpulsecommon-16.1.so,libpulse.so.0,libQt5Core.so.5,libQt5DBus.so.5,libQt5Gui.so.5,libQt5MultimediaGstTools.so.5,libQt5Multimedia.so.5,libQt5MultimediaWidgets.so.5,libQt5Network.so.5,libQt5Widgets.so.5,libQt5XcbQpa.so.5,libsndfile.so.1,libssl.so.3,libswscale.so.7,libsystemd.so.0,libudev.so.1,libunwind.so.8,libva-drm.so.2,libva.so.2,libva-x11.so.2,libvidstab.so.1.2,libvorbisenc.so.2,libvorbis.so.0,libvpx.so.8,libwayland-cursor.so.0,libwayland-egl.so.1,libX11-xcb.so.1,libxcb-glx.so.0,libxcb-icccm.so.4,libxcb-image.so.0,libxcb-keysyms.so.1,libxcb-randr.so.0,libxcb-render.so.0,libxcb-render-util.so.0,libxcb-shape.so.0,libxcb-shm.so.0,libxcb-sync.so.1,libxcb-util.so.1,libxcb-xfixes.so.0,libxcb-xinerama.so.0,libxcb-xinput.so.0,libxcb-xkb.so.1,libXcomposite.so.1,libXcursor.so.1,libXdamage.so.1,libXext.so.6,libXfixes.so.3,libXinerama.so.1,libXi.so.6,libxkbcommon.so.0,libxkbcommon-x11.so.0,libXrandr.so.2,libXrender.so.1} LibDir/
wait $!
rm -rf squashfs-root/usr/lib
wait
rm -rf ./yuzu--*.AppImage
mv ./LibDir ./squashfs-root/usr/lib
wait
wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
chmod +x ./appimagetool-x86_64.AppImage
./appimagetool-x86_64.AppImage ./squashfs-root yuzu.AppImage
wait $!
sudo rm -rf squashfs-root
rm -rf appimagetool-x86_64.AppImage
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
