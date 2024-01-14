```
toolchain

https://github.com/mstorsjo/llvm-mingw
https://github.com/videolan/vlc/blob/master/doc/BUILD-win32.md


libplacebo
meson setup -Dvulkan=disabled -Dgl-proc-addr=disabled -Dopengl=disabled -Dshaderc=disabled -Dlcms=disabled -Ddovi=disabled -Ddemos=false -Dxxhash=disabled -Dunwind=disabled -Dd3d11=enabled -Dglslang=enabled -Ddefault_library=static --cross-file ../test/x86_64-w64-mingw32uwp.txt --reconfigure build

libmpv
meson setup build  -Diconv=disabled -Dcaca=disabled -Dcplugins=disabled -Dlibbluray=disabled -Dlcms2=disabled -Dzimg=disabled  -Dlibarchive=disabled   -Dlibmpv=true -Duwp=enabled -Dcplayer=false -Dgl=disabled -Dvaapi=disabled -Dlua=disabled -Dvulkan=disabled -Dd3d-hwaccel=enabled -Djpeg=disabled -Dd3d9-hwaccel=disabled -Dcuda-hwaccel=disabled -Dspirv-cross=enabled  --cross-file  ../test/x86_64-w64-mingw32uwp.txt --reconfigure

ffmpeg
./configure \
    --pkg-config=pkg-config \
    --cross-prefix=x86_64-w64-mingw32uwp- \
    --enable-gpl \
    --arch=x86_64 \
	--disable-doc \
	--disable-decoder=opus \
	--enable-libgsm \
	--enable-libopenjpeg \
	--disable-debug \
	--disable-protocol=concat \
	--disable-bsfs \
	--disable-libvpx \
	--enable-bsf=vp9_superframe \
	--disable-iconv \
	--disable-avisynth \
	--disable-nvenc \
	--disable-linux-perf \
    --target-os=mingw32uwp \
    --enable-w32threads \
    --disable-dxva2 \
    --disable-programs \
    --disable-muxers \
    --disable-encoders \
    --enable-cross-compile \
    --enable-static \
    --disable-shared \
    --enable-openssl \
    --enable-protocol=https \
    --enable-hwaccels \
    --enable-d3d11va \
    --disable-dxva2 \
    --enable-nonfree \
    --extra-cflags="-Wno-error=incompatible-function-pointer-types" 

    
    openssl
    ./Configure VC-WIN32-UWP
    ./Configure  --cross-compile-prefix=x86_64-w64-mingw32uwp- no-unit-test no-asm no-async no-uplink  enable-static-engine no-tests no-docs  no-shared no-module  no-apps  no-pinshared  no-autoload-config enable-winstore no-deprecated no-ui-console no-stdio no-uplink    mingw64
    
```