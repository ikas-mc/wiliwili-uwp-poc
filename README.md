```
build wiliwili uwp (xbox or pc)   
test only

wiliwili official repo: https://github.com/xfangfang/wiliwili


build:
clone https://github.com/ikas-mc/wiliwili-uwp-poc.git
cd wiliwili-uwp-poc
clone https://github.com/xfangfang/borealis.git
clone https://github.com/xfangfang/wiliwili.git
init submodule  pystring,libpdr 

install vcpkg
edit CMakePresets.json,change vcpkg location
 
open wiliwili-uwp-poc with vscode(with cmake plugins) or other...
see build-ci.bat for detail


todo:
remove win32 api uwp not suppoted
build libmpv for uwp or use winrt MediaPlayer


update:
-20230114
add libmpv for uwp

-20230107
add dash

-20230102
add github action

-20230101
add live 
```






