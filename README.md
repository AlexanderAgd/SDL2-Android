# SDL2-Android
Bash script to download and build:
##### SDL2
##### SDL2_image
##### SD2_mixer
##### SDL2_net
##### SDL2_ttf
##### SDL2_gfx
libraies for Android devices. Requires NDK only, no "gradlew" or java, C/C++ only.  
How it works. Script gets SDL projects from 
<pre>
https://www.libsdl.org/release/
https://www.libsdl.org/projects/
</pre>
and SDL2_gfx from
<pre>
https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/
</pre>
Script downloads and unpacks archives to <PREFIX> directory, sample command: 
<pre>
./build.sh --prefix=/home/user/build --ndkdir=/home/user/NDK --api=16 --arch=armeabi-v7a
</pre>
Where "--prefix" sets build directory, "--ndkdir" sets NDK directory,
"--api" sets minimal Android API level and "--arch" sets architecture of
our librares. Available android API levels you can check in NDK "platforms"
directory and architecture list:
<pre>
armeabi-v7a
arm64-v8a
x86
x86_64
</pre>
build.sh script is a wrapper to "ndk-build" script from NDK directory.
If you plan improve script - NDK guides may be very helpfull.
<pre> 
https://developer.android.com/ndk/guides/android_mk
</pre>
If you get an error when downloading, verify SDL archives versions first and then links 
in the script, version can be found in the begining and links at the end of script. 
To skip download phase you can get all archives manually and put in <PREFIX> folder,
also fix versions of archives in the build.sh if necessary.
Here version of packages tested with build.sh:
<pre>
android-ndk-r16b
android-ndk-r21b
SDL2-2.0.12
SDL2_image-2.0.5
SDL2_mixer-2.0.4
SDL2_net-2.0.1
SDL2_ttf-2.0.15
SDL2_gfx-1.0.4
</pre>


