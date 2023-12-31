```
build wiliwili uwp (xbox or pc)   
test only

wiliwili official repo: https://github.com/xfangfang/wiliwili


build:
clone https://github.com/ikas-mc/wiliwili-uwp-poc.git
cd wiliwili-uwp-poc
clone https://github.com/xfangfang/borealis.git
clone https://github.com/xfangfang/wiliwili.git
init submodule  cpr,libpdr,lunasvg 

install vcpkg
edit CMakePresets.json,change vcpkg location
 
open wiliwili-uwp-poc with vscode(with cmake plugins) or other...


todo:
remove win32 api uwp not suppoted
build libmpv for uwp or use winrt MediaPlayer

update:
-20230101
build uwp package:
https://github.com/ikas-mc/borealis -b wiliwili-uwp-dev
https://github.com/ikas-mc/wiliwili -b uwp-dev

only for test, mp4/flv support,no dash and live

```






