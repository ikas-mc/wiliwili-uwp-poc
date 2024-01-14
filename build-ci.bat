set workDir=%~dp0

git clone https://github.com/microsoft/vcpkg.git
cd vcpkg 
call bootstrap-vcpkg.bat --disable-metrics
set VCPKG_ROOT=%workDir%\vcpkg
cd %workDir%

curl -o cmake-3.28.1-windows-x86_64.zip https://cmake.org/files/v3.28/cmake-3.28.1-windows-x86_64.zip
tar -xf cmake-3.28.1-windows-x86_64.zip
set CMAKE_ROOT=%workDir%\cmake-3.28.1-windows-x86_64

set PATH=%CMAKE_ROOT%\bin;%VCPKG_ROOT%;%PATH%

git clone --depth 1 https://github.com/ikas-mc/wiliwili-uwp-poc
git clone --depth 1 -b wiliwili-uwp-dev https://github.com/ikas-mc/borealis
git clone --depth 1 -b uwp-mpv-dev https://github.com/ikas-mc/wiliwili 

cd wiliwili 
git.exe submodule update  --init -- "library/libpdr" "library/pystring" "library/mongoose"
cd %workDir%

cd wiliwili-uwp-poc
mklink /j  borealis "%workDir%\borealis"
mklink /j  wiliwili "%workDir%\wiliwili"


cmake --preset=uwp

rem build all debug
cmake --build build

rem build wiliwili release
msbuild build\wiliwili-uwp.vcxproj /m /p:configuration="release" /p:platform="x64" /p:AppxBundlePlatforms="x64" /p:UapAppxPackageBuildMode=SideloadOnly /p:PackageOptionalProjectsInIdeBuilds=False

cd %workDir%