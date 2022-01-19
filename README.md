# docker-v2ray-mkcp

快速构建使用mkcp协议的v2ray服务器的docker镜像. 

用法: 

```shell
docker run --restart=always --network host --name v2ray-mkcp kanagawanezumi/v2ray-mkcp
```

运行时会自动打印客户端配置, 复制完毕后, 断开命令行即可.

---

可用环境参数(均有默认值):

- `ADDR`: 服务器ip地址, 用于生成客户端配置, 默认值自行确定的公网ip地址.
- `PORT`: `v2ray`服务在容器内的服务端口, 默认值`3000~30000`随机值, 此端口应对 `udp` 开放
- `UID`: 即`uuid`格式的`id`, 默认值为随机生成的`uuid`.
- `HEADER_TYPE`: 用于`kcp`协议伪装的 `header type`, 默认值`none`.
- `UPLINK_CAPACITY`: 服务端`kcp`协议的 `uplink capacity`, 默认值`100`.
- `DOWNLINK_CAPACITY`: 服务端`kcp`协议的 `downlink capacity`, 默认值`100`.

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