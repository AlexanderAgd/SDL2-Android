# SDL2-Android
Bash script to download and build:
##### SDL2
##### SDL2_image
##### SD2_mixer
##### SDL2_net
##### SDL2_ttf
##### SDL2_gfx
For Android devices, requires NDK only, no grandle or java, C/C++ only.  
How it works. Script gets SDL projects from 
<pre>
https://www.libsdl.org/release/
https://www.libsdl.org/projects/
</pre>
and SDL2_gfx from
<pre>
https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/
</pre>
Download and unpack archives to <PREFIX> directory, sample command: 
<pre>
./build.sh --prefix=/home/user/build --ndkdir=/home/user/NDK --api=16 --arch=armeabi-v7a
</pre>
Where "--prefix" sets build directory, "--ndkdir" sets NDK directory,
"--api" sets minimal Android API level and "--arch" sets architecture of
our librares. Available android API levels you can check in NDK "platforms"
directory, architecture list :
<pre>
armeabi-v7a
arm64-v8a
x86
x86_64
</pre>
build.sh script as main execute command uses "ndk-build" script
If you plan improve script NDK guides may be very helpfull
<pre> 
https://developer.android.com/ndk/guides/android_mk
</pre>
 