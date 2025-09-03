
$workDir = $PSScriptRoot

if (-not ($env:VCPKG_ROOT)) {
    $env:VCPKG_ROOT = $env:VCPKG_INSTALLATION_ROOT
}
if (-not (Test-Path "$env:VCPKG_ROOT\vcpkg.exe")) {
    Write-Error "No vcpkg.exe"
    exit 1
}

if (-not (Test-Path '.\libs\mpv\lib\mpv.lib')) {
    $mpvUrl = 'https://github.com/ikas-mc/wiliwili-uwp-poc/releases/download/0.4/x64-uwp-mpv.zip'
    $mpvHash = '82f8ce29700bf2c586d64c991f602b78c3e9a560c9094f07572db7f7e3ab7cef'
    & curl.exe -L -o '.\x64-uwp-mpv.zip' $mpvUrl
    
    $actualHash = (Get-FileHash '.\x64-uwp-mpv.zip' -Algorithm SHA256).Hash.ToLower()
    if ($actualHash -ne $mpvHash) {
        Write-Error "x64-uwp-mpv.zip hash mismatch: expected $mpvHash but got $actualHash"
        exit 1
    }

    Expand-Archive '.\x64-uwp-mpv.zip' -DestinationPath '.\libs\mpv\' -Force
}

if (-not (Test-Path '.\libs\mpv\lib\mpv.lib')) {
    Write-Error "Failed to install x64-uwp-mpv.zip"
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

& cmake --preset=uwp-release

& msbuild build\wiliwili-uwp.vcxproj /m /p:configuration="release" /p:platform="x64" /p:AppxBundlePlatforms="x64" /p:UapAppxPackageBuildMode="SideloadOnly" /p:PackageOptionalProjectsInIdeBuilds=False
