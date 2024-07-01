#!/bin/bash
workdir=$(
    cd $(dirname $0)
    pwd
)
zipDir=$1
rn=$2

setprop persist.logd.size 8388608

if [ ! -f "/data/local/7za" ]; then
    cp -r "$workdir"/7za /data/local
    chmod 777 /data/local/7za
else
    chmod 777 /data/local/7za
fi

if [ -f /data/local/update ]; then
    rm -rf /data/local/update
fi

echo "开始解析ROM"
/data/local/7za x "$zipDir"/"$rn" -r -o/data/local/update >/dev/null
echo "解析完毕"
chmod a+r -R /data/local/update

if [ -f /data/local/update/payload.bin" ]; then
    echo "ROM核心文件校验成功"
    source /data/local/update/payload_properties.txt
    update_engine_client --payload=file:///data/local/update/payload.bin --update --headers="
FILE_HASH=$FILE_HASH
FILE_SIZE=$FILE_SIZE
METADATA_HASH=$METADATA_HASH
METADATA_SIZE=$METADATA_SIZE"
    logcat -s update_engine:v
else
    echo "ROM核心文件校验失败，请检查ROM完整性！"
fi
