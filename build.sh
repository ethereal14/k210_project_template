#! /bin/bash

dirs=$(pwd)/src/

for dir in $(ls $dirs);do 
    cd $dirs/$dir;
    ProjectName=$(pwd)
done

cd ../../

ProjectName=${ProjectName##*/}
echo $ProjectName
echo $(pwd)

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
