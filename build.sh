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
