
$workDir = $PSScriptRoot

if (-not ($env:VCPKG_ROOT)) {
    $env:VCPKG_ROOT = $env:VCPKG_INSTALLATION_ROOT
}
if (-not (Test-Path "$env:VCPKG_ROOT\vcpkg.exe")) {
    Write-Error "No vcpkg.exe"
    exit 1
}

Invoke-WebRequest -OutFile '.\mpv-4.0.zip' https://github.com/ikas-mc/wiliwili-uwp-poc/releases/download/0.4/mpv-4.0.zip
Expand-Archive '.\mpv-4.0.zip' -DestinationPath '.\libs\mpv\' -Force
if (-not (Test-Path '.\wiliwili-uwp-poc\libs\mpv\lib\mpv.lib')) {
    Write-Error "Failed to install mpv-4.0.zip"
    exit 1
}

if (-not (Test-Path "./borealis")) {
    & git clone --depth 1 -b winrt-dev https://github.com/ikas-mc/borealis
}

if (-not (Test-Path "./wiliwili")) {
    & git clone --depth 1 -b winrt-dev https://github.com/ikas-mc/wiliwili
    Set-Location wiliwili
    & git submodule update  --init -- "library/libpdr" "library/pystring" "library/mongoose"
}

Set-Location $workDir

& cmake --preset=uwp

& msbuild build\wiliwili-uwp.vcxproj /m /p:configuration="release" /p:platform="x64" /p:AppxBundlePlatforms="x64" /p:UapAppxPackageBuildMode="SideloadOnly" /p:PackageOptionalProjectsInIdeBuilds=False
