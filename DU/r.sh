#!/bin/bash

# Colorize and add text parameters
txtbld=$(tput bold)             # Bold
bldgrn=${txtbld}$(tput setaf 2) #  green
txtrst=$(tput sgr0)             # Reset

MODE="$1"

echo -e "${bldgrn}Build script initiated ${txtrst}"

# JACK and NINJA workarounds
echo -e "${bldgrn}Starting JACK and NINJA workarounds ${txtrst}"
#export USE_NINJA=false
rm -rf ~/.jack*
export ANDROID_JACK_VM_ARGS="-Xmx6g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
out/host/linux-x86/bin/jack-admin kill-server
out/host/linux-x86/bin/jack-admin start-server

# Reading mode
if [ ! -z $MODE ]; then
    if [ $MODE == "c" ]; then
       echo -e "${bldgrn}Compiling clean ${txtrst}"
       make clobber;
    else
        echo -e "${bldgrn}Compiling without cleaning out ${txtrst}"
    fi

    if [ $MODE == "d" ]; then
       echo -e "${bldgrn}Compiling dirty ${txtrst}"
       rm out/target/product/shamu/system/build.prop;
       rm -rf out/target/product/shamu/obj/KERNEL_OBJ;
       rm out/target/product/shamu/*.zip;
       rm out/target/product/shamu/*.img;
       rm out/target/product/shamu/*.md5sum;
    fi
else
    echo -e "${bldgrn}Compiling without cleaning out ${txtrst}"
fi

# Setup environment
echo -e "${bldgrn}Starting build environment ${txtrst}"
. build/envsetup.sh
export USE_CCACHE=1

# Start compilation
echo -e "${bldgrn}Starting DU build for shamu ${txtrst}"
lunch du_shamu-userdebug
make bacon

echo -e "${bldgrn}Build script completed ${txtrst}"
