
host=$1
port=$2
host_port=$3
uid=$4
uplink_capacity=$5
downlink_capacity=$6
header_type=$7
cli_port=$8

if [[ ! $uid || $uid = 'none' ]]; then
    # 当用户未传入UID变量时, 为了防止重启容器时重新生成随机ID, 应当在初次生成时保存该uuid
    if [[ ! -e /v2ray_uid ]]; then
        uid=`uuidgen`
        echo $uid > /v2ray_uid
    else
        uid=`cat /v2ray_uid`
    fi
fi

if [[ $host = "\$host" ]]; then
    host=`dig +short myip.opendns.com @resolver1.opendns.com`
    echo "current host: $port"
fi

if [[ $host_port = "\$host_port" ]]; then
    host_port=$host
fi

echo "set uid: ${uid}"

sed -i -e "s/\$port/${port}/g" -e "s/\$uid/${uid}/g" -e "s/\$uplink_capacity/${uplink_capacity}/g" -e "s/\$downlink_capacity/${downlink_capacity}/g" -e "s/\$header_type/${header_type}/g" /root/v2ray-kcp-config.json
sed -i -e "s/\$host_port/${host_port}/g" -e "s/\$host/${host}/g" -e "s/\$uid/${uid}/g" -e "s/\$header_type/${header_type}/g" -e "s/\$cli_port/${cli_port}/g" /root/v2ray-kcp-cli-config.json

# 替换$host_port要在替换$host之前, 否则会替换掉host部分

mv /root/v2ray-kcp-config.json /etc/v2ray/config.json
# echo "v2ray server config"
# cat /etc/v2ray/config.json
echo -e "Ip地址: $host\nV2ray端口: ${host_port}\nuuid: $uid\n推荐安卓客户端: Kitsunebi\n生成的客户端配置:\n"
cat /root/v2ray-kcp-cli-config.json
echo -e "\n"
/usr/bin/v2ray -config /etc/v2ray/config.json

