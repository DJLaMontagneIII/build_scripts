#!/bin/bash

# Colorize and add text parameters
bldblu=${txtbld}$(tput setaf 4) #  blue
txtrst=$(tput sgr0)             # Reset

MODE="$1"

# Reading mode
if [ ! -z $MODE ]; then
    if [ $MODE == "c" ]; then
       echo -e "${bldblu}Building clean ${txtrst}"
       make clobber;
    else
        echo -e "${bldblu}Unset release build flag ${txtrst}"
        unset IS_RELEASED_BUILD
    fi

    if [ $MODE == "d" ]; then
       echo -e "${bldblu}Building dirty ${txtrst}"
       rm out/target/product/bacon/system/build.prop;
       rm -rf out/target/product/bacon/obj/KERNEL_OBJ;
       rm out/target/product/bacon/*.zip;
       rm out/target/product/bacon/*.img;
       rm out/target/product/bacon/*.md5sum;
    fi
else
    echo -e "${bldblu}Unset release build flag ${txtrst}"
    unset IS_RELEASED_BUILD
fi

# Setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh
unset _JAVA_OPTIONS JAVA_TOOL_OPTIONS

# Setup ccache
export USE_CCACHE=1

# For building recovery
export BUILDING_RECOVERY=false

# Prebuilt chromium
export USE_PREBUILT_CHROMIUM=1

# Fix common out folder not being a common
export ANDROID_FIXUP_COMMON_OUT=true

# Lunch device
echo -e "${bldblu}Lunching device... ${txtrst}"
lunch "slim_bacon-userdebug"

# Start compilation
echo -e "${bldblu}Starting build for bacon ${txtrst}"
mka bacon

