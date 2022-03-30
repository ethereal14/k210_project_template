while getopts "b:d:t:" opt
do
    ProjectName=$OPTARG
    case $opt in
        b)

        if [ ! -d "./build/$OPTARG" ];then
            mkdir -p ./build/$OPTARG
        else
            rm -rf ./build/$OPTARG
            mkdir -p ./build/$OPTARG
        fi

        cd build/$OPTARG

        build_opts=" ../.. "
        build_opts="${build_opts} -DPROJ=$OPTARG"
        build_opts="${build_opts} -DTOOLCHAIN=/opt/kendryte-toolchain/bin"
        echo $build_opts
        cmake ${build_opts} && make
        cd ../../
        ;;
        
        d)
        set -f
        IFS=,
        array=($OPTARG)
        kflash -p ${array[0]} ./build/${array[1]}/${array[1]}.bin
        ;;
        t)
        miniterm $OPTARG 115200 --rts 0 --dtr 0
        ;;

        ?)
        echo "未知参数"
        exit 1;;
    esac
done