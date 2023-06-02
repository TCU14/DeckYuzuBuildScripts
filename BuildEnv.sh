#!/bin/bash

source ./renovationrc
#packages taken from yuzu build docs, accepted default on all prompts
sudo pacman -Syu --needed --noconfirm base-devel boost catch2 cmake ffmpeg fmt git glslang libzip lz4 mbedtls ninja nlohmann-json openssl opus qt5 sdl2 zlib zstd zip unzip
wait
#extra packages needed
#patchelf for building the appimage, gtk3 and gst-plugins-bad to provide missing files during appimage creation
sudo pacman -Syu --noconfirm patchelf gtk3 gst-plugins-bad
wait
#clone yuzu
git clone --recursive $DESIREDREPO
wait
cd $REPONAME
mkdir build && cd build

#build yuzu, -DCMAKE_INSTALL_PREFIX="/usr" added to keep paths consistent with docker.sh and upload.sh later on
cmake .. -GNinja -DYUZU_USE_BUNDLED_VCPKG=ON -DYUZU_TESTS=OFF -DCMAKE_CXX_FLAGS="$COMPFLAGS" -DCMAKE_C_FLAGS="$COMPFLAGS" -DCMAKE_INSTALL_PREFIX="/usr"
ninja
wait
#following steps taken and adapted from https://github.com/yuzu-emu/yuzu-mainline/blob/master/.ci/scripts/linux/docker.sh
DESTDIR="$PWD/AppDir" ninja install
wait
rm -vf AppDir/usr/bin/yuzu-cmd AppDir/usr/bin/yuzu-tester

# Download tools needed to build an AppImage
wget -nc https://raw.githubusercontent.com/yuzu-emu/ext-linux-bin/main/gcc/deploy-linux.sh
wget -nc https://raw.githubusercontent.com/yuzu-emu/AppImageKit-checkrt/old/AppRun.sh
wget -nc https://github.com/yuzu-emu/ext-linux-bin/raw/main/appimage/exec-x86_64.so
wait
# Set executable bit
chmod 755 deploy-linux.sh AppRun.sh exec-x86_64.so

# Workaround for https://github.com/AppImage/AppImageKit/issues/828
export APPIMAGE_EXTRACT_AND_RUN=1

mkdir -p AppDir/usr/optional
mkdir -p AppDir/usr/optional/libstdc++
mkdir -p AppDir/usr/optional/libgcc_s

echo "In a moment you will be prompted for your password. This section uses sudo"
sleep 2
#NOTE SUDO ADDED HERE
# Deploy yuzu's needed dependencies
sudo DEPLOY_QT=1 ./deploy-linux.sh AppDir/usr/bin/yuzu AppDir

#NOTE SUDO ADDED HERE
# Workaround for libQt5MultimediaGstTools indirectly requiring libwayland-client and breaking Vulkan usage on end-user systems
sudo find AppDir -type f -regex '.*libwayland-client\.so.*' -delete -print

# Workaround for building yuzu with GCC 10 but also trying to distribute it to Ubuntu 18.04 et al.
# See https://github.com/darealshinji/AppImageKit-checkrt
cp exec-x86_64.so AppDir/usr/optional/exec.so
cp AppRun.sh AppDir/AppRun
cp --dereference /usr/lib/libstdc++.so.6 AppDir/usr/optional/libstdc++/libstdc++.so.6
cp --dereference /lib/libgcc_s.so.1 AppDir/usr/optional/libgcc_s/libgcc_s.so.1

#return to project root
wait
cd ..

#make scripts called by upload.sh executable
chmod a+x .ci/scripts/common/pre-upload.sh .ci/scripts/common/post-upload.sh
#run upload.sh to create AppImage
./.ci/scripts/linux/upload.sh
exit 0
