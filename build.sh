#!/bin/bash

###  FIX HERE VERSION IF NECESSARY  ###
###  LINKS ARE AT THE AND OF SCRIPT  ###
src_SDL2=SDL2-2.0.12
src_SDL2_image=SDL2_image-2.0.5
src_SDL2_mixer=SDL2_mixer-2.0.4
src_SDL2_net=SDL2_net-2.0.1
src_SDL2_ttf=SDL2_ttf-2.0.15
src_SDL2_gfx=SDL2_gfx-1.0.4

# Color messages #
txtbld=$(tput bold)
txtred=$(tput setaf 1)
txtgreen=$(tput setaf 2)
txtrst=$(tput sgr0)

# Global Variables #
DOWNLOADER=""
NDK_DIR="$ANDROID_NDK_HOME"
NDK_OPTIONS="$NDK_OPTIONS"
INSTALL_DIR=$(pwd)
ARCH="armeabi-v7a"
API="16"
MK_ADDON=""
SED=""
cp_opt=""

function MESSAGE { printf "$txtgreen$1 $txtrst\n"; }

function ERROR 
{ 
    if [ $? -ne 0 ]; then 
        printf "$txtred\nERROR: $1 $txtrst\n\n"; 
        exit 1; 
    fi
}

function STATUS
{
    if [ $? -ne 0 ]; then 
        printf "$txtred\nERROR: $1 $txtrst\n\n"; 
        exit 1;
    else
        printf "$txtgreen$1 - done $txtrst\n";    
    fi
}

function downloadPackage
{
	MESSAGE "Downloading $1"
    $DOWNLOADER $1
    ERROR "Could not download $1 \nFix address or package version in the script"
    MESSAGE "Downloaded $1"
}

function buildPackage
{
    src=$1
    url=$2

    if [[ ! -e "$src" ]]; then
        if [[ ! -e "$src.tar.gz" ]]; then
        	downloadPackage $url;
        fi

        tar xzf $INSTALL_DIR/$src.tar.gz -C $INSTALL_DIR;
        STATUS "Unpack $src.tar.gz";
    fi    

    case $src in
        "$src_SDL2")
            build_SDL2 ;;
        "$src_SDL2_image")
            build_SDL2_image ;;            
        "$src_SDL2_mixer")
            build_SDL2_mixer ;;
        "$src_SDL2_net")
            build_SDL2_net ;;
        "$src_SDL2_ttf")
            build_SDL2_ttf ;;
        "$src_SDL2_gfx")
            build_SDL2_gfx ;;    
        *)
            printf "$txtred ERROR: unknown parameter \"$src\"\n $txtrst"
            exit 1 ;;
    esac
}

function build_SDL2
{
    if [[ -e "$INSTALL_DIR/lib/$ARCH/libSDL2.so" ]]; then return 0; fi

    $NDK_DIR/ndk-build -C $INSTALL_DIR/$src_SDL2 NDK_PROJECT_PATH=$NDK_DIR \
        APP_BUILD_SCRIPT=$INSTALL_DIR/$src_SDL2/Android.mk \
        APP_PLATFORM=android-$API APP_ABI=$ARCH $NDK_OPTIONS \
        NDK_OUT=$INSTALL_DIR/obj NDK_LIBS_OUT=$INSTALL_DIR/obj/libs
    STATUS "Building SDL2"

    printf "$txtgreen"
    cp $cp_opt $INSTALL_DIR/obj/libs/$ARCH/*.* $INSTALL_DIR/lib/$ARCH
    cp $cp_opt $INSTALL_DIR/obj/local/$ARCH/lib*.* $INSTALL_DIR/liball/$ARCH
    printf "$txtrst"  
}

function build_SDL2_image
{
    if [[ -e "$INSTALL_DIR/lib/$ARCH/libSDL2_image.so" ]]; then return 0; fi
    
    DIR=$INSTALL_DIR/$src_SDL2_image
    if [[ -e $DIR/tmp.mk ]]; then mv -f $DIR/tmp.mk $DIR/Android.mk; fi
    cp -fva $DIR/Android.mk $DIR/tmp.mk
    $SED -i "/(call my-dir)/a $MK_ADDON" $DIR/Android.mk

    $NDK_DIR/ndk-build -C $DIR NDK_PROJECT_PATH=$NDK_DIR APP_BUILD_SCRIPT=$DIR/Android.mk \
        APP_PLATFORM=android-$API APP_ABI=$ARCH APP_ALLOW_MISSING_DEPS=true $NDK_OPTIONS \
        NDK_OUT=$INSTALL_DIR/obj NDK_LIBS_OUT=$INSTALL_DIR/obj/libs
    STATUS "Building SDL2_image"

    printf "$txtgreen"
    cp $cp_opt $INSTALL_DIR/obj/libs/$ARCH/*.* $INSTALL_DIR/lib/$ARCH
    cp -avn $INSTALL_DIR/obj/local/$ARCH/lib*.* $INSTALL_DIR/liball/$ARCH
    printf "$txtrst"

    mv -f $DIR/tmp.mk $DIR/Android.mk
}

function build_SDL2_mixer
{
    if [[ -e "$INSTALL_DIR/lib/$ARCH/libSDL2_mixer.so" ]]; then return 0; fi
    
    DIR=$INSTALL_DIR/$src_SDL2_mixer
    if [[ -e $DIR/tmp.mk ]]; then mv -f $DIR/tmp.mk $DIR/Android.mk; fi
    cp -fva $DIR/Android.mk $DIR/tmp.mk
    $SED -i "/(call my-dir)/a $MK_ADDON" $DIR/Android.mk

	$NDK_DIR/ndk-build -C $DIR NDK_PROJECT_PATH=$NDK_DIR APP_BUILD_SCRIPT=$DIR/Android.mk \
        APP_PLATFORM=android-$API APP_ABI=$ARCH APP_ALLOW_MISSING_DEPS=true $NDK_OPTIONS \
        NDK_OUT=$INSTALL_DIR/obj NDK_LIBS_OUT=$INSTALL_DIR/obj/libs
    STATUS "Building SDL2_mixer"

    printf "$txtgreen"
    cp $cp_opt $INSTALL_DIR/obj/libs/$ARCH/*.* $INSTALL_DIR/lib/$ARCH
    cp -avn $INSTALL_DIR/obj/local/$ARCH/lib*.* $INSTALL_DIR/liball/$ARCH
    printf "$txtrst"

    mv -f $DIR/tmp.mk $DIR/Android.mk
}

function build_SDL2_net
{
    if [[ -e "$INSTALL_DIR/lib/$ARCH/libSDL2_net.so" ]]; then return 0; fi
    
    DIR=$INSTALL_DIR/$src_SDL2_net
    if [[ -e $DIR/tmp.mk ]]; then mv -f $DIR/tmp.mk $DIR/Android.mk; fi
    cp -fva $DIR/Android.mk $DIR/tmp.mk
    $SED -i "/(call my-dir)/a $MK_ADDON" $DIR/Android.mk

	$NDK_DIR/ndk-build -C $DIR NDK_PROJECT_PATH=$NDK_DIR APP_BUILD_SCRIPT=$DIR/Android.mk \
        APP_PLATFORM=android-$API APP_ABI=$ARCH APP_ALLOW_MISSING_DEPS=true $NDK_OPTIONS \
        NDK_OUT=$INSTALL_DIR/obj NDK_LIBS_OUT=$INSTALL_DIR/obj/libs
    STATUS "Building SDL2_net"

    printf "$txtgreen"
    cp $cp_opt $INSTALL_DIR/obj/libs/$ARCH/*.* $INSTALL_DIR/lib/$ARCH
    cp -avn $INSTALL_DIR/obj/local/$ARCH/lib*.* $INSTALL_DIR/liball/$ARCH
    printf "$txtrst"

    mv -f $DIR/tmp.mk $DIR/Android.mk	
}

function build_SDL2_ttf
{
    if [[ -e "$INSTALL_DIR/lib/$ARCH/libSDL2_ttf.so" ]]; then return 0; fi
    
    DIR=$INSTALL_DIR/$src_SDL2_ttf
    if [[ -e $DIR/tmp.mk ]]; then mv -f $DIR/tmp.mk $DIR/Android.mk; fi
    cp -fva $DIR/Android.mk $DIR/tmp.mk
    $SED -i "/(call my-dir)/a $MK_ADDON" $DIR/Android.mk

	$NDK_DIR/ndk-build -C $DIR NDK_PROJECT_PATH=$NDK_DIR APP_BUILD_SCRIPT=$DIR/Android.mk \
        APP_PLATFORM=android-$API APP_ABI=$ARCH APP_ALLOW_MISSING_DEPS=true $NDK_OPTIONS \
        NDK_OUT=$INSTALL_DIR/obj NDK_LIBS_OUT=$INSTALL_DIR/obj/libs
    STATUS "Building SDL2_ttf"

    printf "$txtgreen"
    cp $cp_opt $INSTALL_DIR/obj/libs/$ARCH/*.* $INSTALL_DIR/lib/$ARCH
    cp -avn $INSTALL_DIR/obj/local/$ARCH/lib*.* $INSTALL_DIR/liball/$ARCH
    printf "$txtrst"

    mv -f $DIR/tmp.mk $DIR/Android.mk	
}

function build_SDL2_gfx
{
    if [[ -e "$INSTALL_DIR/lib/$ARCH/libSDL2_gfx.so" ]]; then return 0; fi
    
    DIR=$INSTALL_DIR/$src_SDL2_gfx

    files=""
    for out in $(ls $DIR/*.c)
    do
        files+="$(echo "$out" | rev | cut -c 1- | rev) "
    done

    echo "LOCAL_PATH := \$(call my-dir)" > $DIR/Android.mk
    $SED -i "/(call my-dir)/a $MK_ADDON" $DIR/Android.mk
    echo "include \$(CLEAR_VARS)" >> $DIR/Android.mk
    echo "LOCAL_MODULE := SDL2_gfx" >> $DIR/Android.mk
    echo "LOCAL_C_INCLUDES := \$(LOCAL_PATH)" >> $DIR/Android.mk
    echo "LOCAL_SRC_FILES := $files" >> $DIR/Android.mk
    echo "LOCAL_SHARED_LIBRARIES := SDL2" >> $DIR/Android.mk
    echo "LOCAL_EXPORT_C_INCLUDES += \$(LOCAL_C_INCLUDES)" >> $DIR/Android.mk
    echo "include \$(BUILD_SHARED_LIBRARY)" >> $DIR/Android.mk
 
    $NDK_DIR/ndk-build -C $DIR NDK_PROJECT_PATH=$NDK_DIR APP_BUILD_SCRIPT=$DIR/Android.mk \
        APP_PLATFORM=android-$API APP_ABI=$ARCH APP_ALLOW_MISSING_DEPS=true $NDK_OPTIONS \
        NDK_OUT=$INSTALL_DIR/obj NDK_LIBS_OUT=$INSTALL_DIR/obj/libs
    STATUS "Building SDL2_gfx"

    printf "$txtgreen"
    cp $cp_opt $INSTALL_DIR/obj/libs/$ARCH/*.* $INSTALL_DIR/lib/$ARCH
    cp -avn $INSTALL_DIR/obj/local/$ARCH/lib*.* $INSTALL_DIR/liball/$ARCH
    printf "$txtrst"
}

function checkArch
{
    case "$1" in
        "armeabi-v7a") ;;            
        "arm64-v8a") ;;
        "x86") ;;
        "x86_64") ;;
        "all")
            printf "\n$txtred \"--arch=$1\" only one ABI build allowed per command!\n$txtrst"
            usage; exit ;;
        *)
            printf "\n$txtred ERROR: Unknown ABI \"--arch=$1\"\n"
            printf " Available ABI:  armeabi-v7a  arm64-v8a  x86  x86_64 \n\n$txtrst"
            usage; exit ;;
    esac
}

function osCommands
{
   case "$(uname -s)" in
   Darwin)
     cmd_gsed="$(which gsed)"
     if [[ ! $cmd_gsed ]]; then
        printf "$txtred\n    Please install gsed\n"
        printf "\$ brew install gnu-sed\n"
        printf "    and export PATH to gsed if necessary, sample command:\n"
        printf "\$ export PATH=\"/usr/local/opt/gnu-sed/libexec/gnubin:\$PATH\"$txtrst\n\n"
        exit;
     fi
     SED="gsed";
     cp_opt="-avf" ;;
   *)
     SED="sed"; cp_opt="-avu" ;;
   esac
}

function parseArgs
{
    if [[ "$1" == "" ]]; then usage; exit; fi 

    while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage; exit ;;
        --prefix)
            INSTALL_DIR=$VALUE ;;
        --ndkdir)
            NDK_DIR=$VALUE ;;
        --arch)
            ARCH=$VALUE
            checkArch "$VALUE" ;;
        --api)
            API=$VALUE ;;
        *)
            printf "$txtred ERROR: unknown parameter \"$PARAM\"\n $txtrst"
            usage; exit ;;
    esac
    shift
    done
}

function usage
{
    printf "$txtgreen"
    printf "\n\t Usage: ./build.sh <options>\n" 
    printf "\n\t -h --help                Brief help"
    printf "\n\t --prefix=<PREFIX>        Download and build in PREFIX, default path is \"build.sh\" script directory"
    printf "\n\t --ndkdir=<PATH>          Path to NDK directory"
    printf "\n\t --arch=<arch>            Set architecture you want to build, example --arch=armeabi-v7a"
    printf "\n\t --api=<id>               Set minimal Android API level, example --api=16"
    printf "\n\n\t              Example of usage:"
    printf "\n\n\t ./build.sh --prefix=/home/user/build --ndkdir=/home/user/NDK --api=16 --arch=armeabi-v7a \n\n$txtrst"
}

#################################################################################

parseArgs "$@"
osCommands

MESSAGE "Used \"NDK_OPTIONS\":\n$NDK_OPTIONS"

NDK=$NDK_DIR/ndk-build

if [[ ! -e "$NDK" ]]; then
    printf "$txtred\nERROR: Can not find ndk-build $txtrst\n\n"; 
    exit 1;        
fi

DOWNLOADER=$(which curl);

if [[ ! $DOWNLOADER ]]; 
    then DOWNLOADER=$(which wget);
    else DOWNLOADER="$DOWNLOADER -O -f -L"
fi
ERROR "Please install curl or wget."

if [[ $INSTALL_DIR && ! -e $INSTALL_DIR ]]; then
    mkdir -p $INSTALL_DIR
    STATUS "Create $INSTALL_DIR directory"
fi

if [[ ! -e $INSTALL_DIR/lib/$ARCH ]]; then
    mkdir -p $INSTALL_DIR/lib/$ARCH
    STATUS "Create $INSTALL_DIR/lib directory"
    info="Stripped libraries"
    echo $info > $INSTALL_DIR/lib/INFO
fi

if [[ ! -e $INSTALL_DIR/liball/$ARCH ]]; then
    mkdir -p $INSTALL_DIR/liball/$ARCH
    STATUS "Create $INSTALL_DIR/liball directory"
    info="Static & shared non stripped libraries"
    echo $info > $INSTALL_DIR/liball/INFO
fi

MK_ADDON+="include \$(CLEAR_VARS)\n"
MK_ADDON+="LOCAL_MODULE := SDL2\n"
MK_ADDON+="LOCAL_SRC_FILES := $INSTALL_DIR/lib/$ARCH/libSDL2.so\n"
MK_ADDON+="LOCAL_EXPORT_C_INCLUDES += $INSTALL_DIR/$src_SDL2/include\n"
MK_ADDON+="include \$(PREBUILT_SHARED_LIBRARY)"

pushd $INSTALL_DIR      ### FIX URL HERE IF DOWNLOAD FAILS ### 

URL=https://www.libsdl.org/release/$src_SDL2.tar.gz
buildPackage $src_SDL2 $URL

URL=https://www.libsdl.org/projects/SDL_image/release/$src_SDL2_image.tar.gz
buildPackage $src_SDL2_image $URL
 
URL=https://www.libsdl.org/projects/SDL_mixer/release/$src_SDL2_mixer.tar.gz
buildPackage $src_SDL2_mixer $URL

URL=https://www.libsdl.org/projects/SDL_net/release/$src_SDL2_net.tar.gz
buildPackage $src_SDL2_net $URL

URL=https://www.libsdl.org/projects/SDL_ttf/release/$src_SDL2_ttf.tar.gz
buildPackage $src_SDL2_ttf $URL

URL=http://www.ferzkopp.net/Software/SDL2_gfx/$src_SDL2_gfx.tar.gz
buildPackage $src_SDL2_gfx $URL

popd

rm -rf "$INSTALL_DIR/obj"

MESSAGE "\n\n ******** DONE ******** \n\n"
