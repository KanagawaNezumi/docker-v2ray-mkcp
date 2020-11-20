# docker-v2ray-mkcp

快速构建使用mkcp协议的v2ray服务器的docker镜像. 

用法: 

```shell
docker run --restart=always --network host --name v2ray-mkcp kanagawanezumi/v2ray-mkcp
```

运行时会自动打印客户端配置, 复制完毕后, 断开命令行即可.

---

可用环境参数(均有默认值):

- HOST: 服务器ip地址, 用于生成客户端配置, 默认值为dig命令自行确定的公网ip地址.
- PORT: v2ray服务在容器内的服务端口, 默认值6324.
- UID: 即uuid格式的id, 默认值为随机生成的uuid.
- HOST_PORT: 在手动映射端口时应当指定的host端口, 用于生成客户端配置, 默认与port保持一致.
- UPLINK_CAPACITY: 服务端kcp协议的 uplink capacity, 默认值100.
- DOWNLINK_CAPACITY: 服务端kcp协议的 downlink capacity, 默认值100.
- HEADER_TYPE: 用于kcp协议伪装的 header type, 默认值none.
- CLI_PORT: 客户端运行端口, 用于生成客户端配置, 默认值1080.

示例(更改端口号为2020, 伪装类型为utp): 

```shell
docker run \
    --restart=always \
    --network host \
    --name v2ray-mkcp \
    -e PORT=2020 \
    -e HEADER_TYPE=utp \
    kanagawanezumi/v2ray-mkcp
```

---

附: vultr主机(CentOS 8 系统)使用此镜像的命令行记录

```shell
yum -y install yum-utils firewalld
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce docker-ce-cli containerd.io --allowerasing
systemctl enable docker && systemctl start docker
systemctl enable firewalld && systemctl start firewalld
firewall-cmd --zone=public --add-port=6324/udp --permanent 
firewall-cmd --reload 
docker run --restart=always --network host --name v2ray-mkcp kanagawanezumi/v2ray-mkcp
```

---

注: 自行 build 时请添加`--network host`, 否则可能出现网络问题.
