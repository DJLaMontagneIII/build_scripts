#!/bin/bash

# Colorize and add text parameters
txtbld=$(tput bold)             # Bold
bldgrn=${txtbld}$(tput setaf 2) #  green
txtrst=$(tput sgr0)             # Reset

MODE="$1"

# Reading mode
if [ ! -z $MODE ]; then
    if [ $MODE == "c" ]; then
       echo -e "${bldgrn}Building clean ${txtrst}"
       make clobber;
       rm s.txt;
    else
        echo -e "${bldgrn}Unset release build flag ${txtrst}"
        unset IS_RELEASED_BUILD
    fi

    if [ $MODE == "d" ]; then
       echo -e "${bldgrn}Building dirty ${txtrst}"
       rm out/target/product/shamu/system/build.prop;
       rm -rf out/target/product/shamu/obj/KERNEL_OBJ;
       rm out/target/product/shamu/*.zip;
       rm out/target/product/shamu/*.img;
       rm out/target/product/shamu/*.md5sum;
       rm s.txt;
    fi
else
    echo -e "${bldgrn}Unset release build flag ${txtrst}"
    unset IS_RELEASED_BUILD
    rm s.txt;
fi

# Setup environment
echo -e "${bldgrn}Setting up build environment ${txtrst}"
. build/envsetup.sh
export USE_CCACHE=1

# Temp fix for jack heap size error
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4096m"
out/host/linux-x86/bin/jack-admin kill-server
out/host/linux-x86/bin/jack-admin start-server

# Start compilation
echo -e "${bldgrn}Starting Dirty Unicorns build for shamu ${txtrst}"
echo shamu build started > s.txt
lunch du_shamu-userdebug
mka bacon
echo shamu build complete > s.txt
