FROM alpine:latest
LABEL maintainer "V2Fly Community <dev@v2fly.org>"

WORKDIR /root
ARG TARGETPLATFORM
VOLUME /etc/v2ray
COPY v2ray.sh /root/v2ray.sh
COPY v2ray-kcp-config.json /root/v2ray-kcp-config.json
COPY v2ray-kcp-cli-config.json /root/v2ray-kcp-cli-config.json
COPY v2ray-kcp-entrypoint.sh /root/v2ray-kcp-entrypoint.sh

ENV host=\$host
ENV port=6324
ENV host_port=${port}
ENV uid=none
ENV uplink_capacity=100
ENV downlink_capacity=100
ENV header_type=none
ENV cli_port=1080

RUN set -ex \
	&& apk add --no-cache tzdata openssl ca-certificates util-linux bind-tools \
	&& mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
	&& chmod +x /root/v2ray.sh \
	&& chmod +x /root/v2ray-kcp-entrypoint.sh \
	&& /root/v2ray.sh 

CMD /root/v2ray-kcp-entrypoint.sh ${host} ${port} ${host_port} ${uid} ${uplink_capacity} ${downlink_capacity} ${header_type} ${cli_port}
