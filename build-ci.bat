set workDir=%~dp0

rem git clone https://github.com/microsoft/vcpkg.git
rem cd vcpkg 
rem call bootstrap-vcpkg.bat --disable-metrics
rem set VCPKG_ROOT=%workDir%\vcpkg
rem cd %workDir%

rem curl -o cmake-3.28.1-windows-x86_64.zip https://cmake.org/files/v3.28/cmake-3.28.1-windows-x86_64.zip
rem tar -xf cmake-3.28.1-windows-x86_64.zip
rem set CMAKE_ROOT=%workDir%\cmake-3.28.1-windows-x86_64

rem set PATH=%CMAKE_ROOT%\bin;%VCPKG_ROOT%;%PATH%

git clone --depth 1 https://github.com/ikas-mc/wiliwili-uwp-poc
git clone --depth 1 -b wiliwili-uwp-dev https://github.com/ikas-mc/borealis
git clone --depth 1 -b uwp-mpv-dev https://github.com/ikas-mc/wiliwili 

cd wiliwili 
git.exe submodule update  --init -- "library/libpdr" "library/pystring" "library/mongoose"
cd %workDir%

cd wiliwili-uwp-poc
mklink /j  borealis "%workDir%\borealis"
mklink /j  wiliwili "%workDir%\wiliwili"


rem cmake --preset=uwp
rem cmake --build build

llvm-strip --discard-all libs\libmpv\bin\libmpv-2.dll

cmake --preset=uwp-release
rem cmake --build build
msbuild build\wiliwili-uwp.vcxproj /m /p:configuration="release" /p:platform="x64" /p:AppxBundlePlatforms="x64" /p:UapAppxPackageBuildMode="SideloadOnly" /p:PackageOptionalProjectsInIdeBuilds=False

cd %workDir%
