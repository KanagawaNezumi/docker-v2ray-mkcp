#!/bin/sh

host=$1
port=$2
host_port=$3
uid=$4
uplink_capacity=$5
downlink_capacity=$6
header_type=$7
cli_port=$8
is_restart=false


if [[ ! $uid || $uid = 'none' ]]; then
    if [[ ! -e /v2ray_uid ]]; then
        uid=`uuidgen`
        echo $uid > /v2ray_uid
        
    else
        uid=`cat /v2ray_uid`
        is_restart=true
    fi
fi

if [[ $host = "\$host" ]]; then
    host=`dig +short myip.opendns.com @resolver1.opendns.com`
    echo "current host: $host"
fi

if [[ $host_port = "\$host_port" ]]; then
    host_port=$port
fi

echo "set uid: ${uid}"
echo "is_restart, ${is_restart}"

if [[ $is_restart = false ]]; then
    sed -i -e "s/\$port/${port}/g" -e "s/\$uid/${uid}/g" -e "s/\$uplink_capacity/${uplink_capacity}/g" -e "s/\$downlink_capacity/${downlink_capacity}/g" -e "s/\$header_type/${header_type}/g" v2ray-kcp-config.json
    sed -i -e "s/\$host_port/${host_port}/g" -e "s/\$host/${host}/g" -e "s/\$uid/${uid}/g" -e "s/\$header_type/${header_type}/g" -e "s/\$cli_port/${cli_port}/g" v2ray-kcp-cli-config.json

    mv v2ray-kcp-config.json /etc/v2ray/config.json
    mv v2ray-kcp-cli-config.json /etc/v2ray/cli-config.json
    # echo "v2ray server config"
    # cat /etc/v2ray/config.json
    echo -e "Ip地址: $host\nV2ray端口: ${host_port}\nuuid: $uid\n推荐安卓客户端: Kitsunebi\n推荐客户端配置:"
    echo "#=====================================================================================#"
    cat /etc/v2ray/cli-config.json
    echo -e "#=====================================================================================#\n"
fi

/usr/bin/v2ray -config /etc/v2ray/config.json
