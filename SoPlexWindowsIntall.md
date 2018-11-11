# Install SoPlex on Windows
1. 解压源码, 新建 build 目录
2. 安装`vcpkg`管理依赖 [GitHub](https://github.com/Microsoft/vcpkg)
    + 安装 `zlib`
    + 安装 `mpir` 替代 `gmp`
3. 安装`CMake`, 官网安装包安装 [下载](https://cmake.org/files/v3.13/cmake-3.13.0-rc3-win64-x64.msi)
4. `cmake .. -DCMAKE_TOOLCHAIN_FILE=[vcpkg root]\scripts\buildsystems\vcpkg.cmake`
5. 将`soplex.cpp`中`mpir_version`替换为`__MPIR_VERSION`, 这到底是谁写的不标准.
6. 生成 -> 生成解决方案

简化后步骤:
1. msys2 中打开
2. `sh mk-soplex-win.sh`
3. 进入`soplex/build`双击运行bat文件
4. 在VS中切换为Release生成解决方案

# 后记
在 windows 上编译 UNIX 软件有以下几种选择:
+ Cygwin -- 安装包太难用了, 滚
+ MinGW
+ MinGW-w64
+ MSYS2
+ CMake + Visual Studio

## Cygwin
软件包管理居然只能重新运行安装程序, 而且安装程序难用的一逼, 差评!

## MinGW
难以解决依赖问题

## MinGW-w64 + Win-Builds
Win-Builds 内置了许多 GNU 包, 可以解决依赖问题, 但是同样的代码编译报错是最难受的.

此外, MinGW-w64 还是可以在别的平台直接交叉编译的. 但是, Mac下似乎比较坑, Linux下也只试成功了简单项目的编译. 

## MSYS2
MSYS2 是对  Cygwin 和 MinGW+MSYS 的升级实现, 包管理非常舒服, 只需要`pacman`之后重启自身即可. 而且也是一个非常舒服的 linux 子系统, 用来做 ssh 还是很棒的.

但是编译结果似乎依赖`msys2.dll`之类的东西.

另一个严重的问题也是编译不兼容的问题, 因为它其实和 Cygwin 和 MinGW 是一个系列的.

## CMake + VS
这应该是最兼容的用法, 不过需要解决依赖问题. 有了微软自家的 vcpkg , 这个就好用多了. 

还有虽然 vs 自带 cmake 可以直接读取 CMakeList 生成项目, 但是似乎是个坑.

不过就是图形界面操作的确没命令行爽.
 
还有也顺带生成了 lib 和 dll, 可以自己写接口调用了

# 常见编译流程
+ CMake系列: cmake + native make
+ linux 原生 configure + make 

# 再后记
凸(艹皿艹 )!!!! GMP居然官网有预编译版, 操. [地址](https://cs.nyu.edu/~exact/core/gmp/index.html)

# Cross Compiling on Linux
Linux上, 安装  mingw-w64 之后, 创建 `mingw.cmake`
```
# the name of the target operating system
SET(CMAKE_SYSTEM_NAME Windows)

# which compilers to use for C and C++
SET(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
SET(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
SET(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)

# here is the target environment located
SET(CMAKE_FIND_ROOT_PATH x86_64-w64-mingw32)

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```
然后
```
cmake .. -DCMAKE_TOOLCHAIN_FILE=mingw.cmake
```
问题就是`mingw-g++` multiple definition 
```
cmake .. -DCMAKE_EXE_LINKER_FLAGS="-Wl,-static,--allow-multiple-definition"
```
解决了这个问题, 但是在 Linux 上找不到库, 在 msys2 上最终搞不定 soplex::infinity