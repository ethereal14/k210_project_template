# Kendryte K210 standalone SDK

[![Build Status](https://travis-ci.org/kendryte/kendryte-standalone-sdk.svg)](https://travis-ci.org/kendryte/kendryte-standalone-sdk)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This SDK is for Kendryte K210 without OS support.
If you have any questions, please be free to contact us.

## 更新 2022-03-30

原来的文件`build.sh`和目录`build`一样，使用`tab`键不能完全补齐，很不爽就把文件名改了

其他和`build.sh`一样操作

## 更新 2022-03-18

以前的版本新建一个工程就得把`standalone-sdk`拷贝一次，很麻烦，仔细阅读官方的`README`后发现在使用 cmake 构建工程是只需要指明`-DPROJ`的值就可以了。

例如：

```
-src
    -led
    -uart
    -hello_world
```

在这个目录下我们只需要`cmake .. -DPROJ=<ProjectName> -DTOOLCHAIN=/opt/kendryte-toolchain/` 就可以构建出我们的工程。所以`build.sh`也做出相应的改进：

- 构建：输入 `./build.sh -b [ProjectName]`
- 烧录：输入 `./build.sh -d [Port],[ProjectName]`，Port 为串口号
- 打开串口：输入`./build.sh -t`，打开串口也需要指定串口号

示例：

```shell
./build.sh -b led -d /dev/ttyUSB0,led -t /dev/ttyUSB0
```

## 更新 2022-03-17

增加了构建(build)、烧录(download)、打开串口(terminal)的选项。

- 构建：输入 `./build.sh -b`
- 烧录：输入 `./build.sh -d`，烧录需要指定串口号，Linux 下可以通过`ls /dev/tty*`查看
- 打开串口：输入`./build.sh -t`，打开串口也需要指定串口号

烧录功能使用了勘智官方提供的 kflash、打开串口使用的是 miniterm

在使用 k210 串口时，发现串口默认模式是 rs232，所以在使用时需要把 miniterm 的 RTS、DTR 打开。我们可以使用`void uart_set_work_mode(uart_device_number_t uart_channel, uart_work_mode_t work_mode)`将串口设置成普通模式，这样我们需要在 miniterm 中把 RTS、DTR 设置为 0。这里默认设置的 0

## 说明

在官方的 SDK 上增加了`build.sh`的 shell 脚本。目的是为了复杂减少命令的输入。更多功能有待完善。

```shell
dirs=$(pwd)/src/

for dir in $(ls $dirs);do
    cd $dirs/$dir;
    ProjectName=$(pwd)
done

cd ../../

ProjectName=${ProjectName##*/}

while getopts "bd:t:c" opt
do
    case $opt in
        b)

        if [ ! -d "./build/" ];then
            mkdir ./build
        else
            rm -rf ./build
            mkdir ./build
        fi

        cd build

        build_opts=" .. "
        build_opts="${build_opts} -DPROJ=${ProjectName}"
        build_opts="${build_opts} -DTOOLCHAIN=/opt/kendryte-toolchain/bin"
        cmake ${build_opts}
        make
        ;;

        d)
        kflash -p $OPTARG ./build/${ProjectName}.bin
        ;;
        t)
        miniterm $OPTARG 115200 --rts 0 --dtr 0
        ;;

        c)
        rm -rf ./build
        ;;
        ?)
        echo "未知参数"
        exit 1;;
    esac
done

```

## Usage

If you want to start a new project, for instance, `hello_world`, you only need to:

- Linux and OSX

`mkdir` your project in `src/`, `cd src && mkdir hello_world`, then put your codes in it, enter SDK root directory and build it.

```bash
mkdir build && cd build
cmake .. -DPROJ=<ProjectName> -DTOOLCHAIN=/opt/kendryte-toolchain/bin && make
```

- Windows

Download and install latest CMake.

[Download cmake-3.14.1-win64-x64.msi](https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1-win64-x64.msi)

Download and install latest toolchain.

[Download kendryte-toolchain-win-i386-8.2.0-20190409.tar.xz](https://github.com/kendryte/kendryte-gnu-toolchain/releases/download/v8.2.0-20190409/kendryte-toolchain-win-i386-8.2.0-20190409.tar.xz)

Open a Windows Powershell, cd to Project directory.

`mkdir` your project in `src/`, `cd src && mkdir hello_world`, then put your codes in it, and build it.

```powershell
$env:Path="E:\kendryte-toolchain\bin;C:\Program Files\CMak
e\bin" +  $env:Path

mkdir build && cd build
cmake -G "MinGW Makefiles" ../../../..
make
```

You will get 2 key files, `hello_world` and `hello_world.bin`.

1. If you are using JLink to run or debug your program, use `hello_world`
2. If you want to flash it in UOG, using `hello_world.bin`, then using flash-tool(s) burn <ProjectName>.bin to your flash.

This is very important, don't make a mistake in files.
