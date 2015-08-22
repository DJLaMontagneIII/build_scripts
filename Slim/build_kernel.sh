#!/bin/bash

# Colorize and add text parameters
bldblu=${txtbld}$(tput setaf 4) #  blue
txtrst=$(tput sgr0)             # Reset

MODE="$1"

# Time of build startup
res1=$(date +%s.%N)

# Reading mode
if [ $MODE == "c" ]; then
   echo -e "${bldblu}Cleaning up out folder ${txtrst}"
   make clobber;
fi

# Setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh
export USE_CCACHE=1

# Lunch device
echo -e "${bldblu}Lunching bacon... ${txtrst}"
lunch "slim_bacon-userdebug"

# Start compilation
echo -e "${bldblu}Building kernel for bacon ${txtrst}"
mka bootzip

