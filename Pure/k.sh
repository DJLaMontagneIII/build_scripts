#!/bin/bash

# Colorize and add text parameters
bldblu=${txtbld}$(tput setaf 4) #  blue
txtrst=$(tput sgr0)             # Reset

MODE="$1"

# Reading mode
if [ ! -z $MODE ]; then
    if [ $MODE == "c" ]; then
       echo -e "${bldgrn}Building clean ${txtrst}"
       make clobber;
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
    fi
else
    echo -e "${bldgrn}Unset release build flag ${txtrst}"
    unset IS_RELEASED_BUILD
fi

# Setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh
export USE_CCACHE=1
lunch "nexus_shamu-user"

# Start compilation
echo -e "${bldblu}Building kernel for shamu ${txtrst}"
mka bootimage
