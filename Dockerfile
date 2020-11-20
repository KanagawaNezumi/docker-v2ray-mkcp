FROM alpine:latest
LABEL maintainer "V2Fly Community <dev@v2fly.org>"

WORKDIR /v2ray-mkcp
ARG TARGETPLATFORM
VOLUME /etc/v2ray
COPY . .

ENV HOST=\$host \
	PORT=6324 \
	HOST_PORT=\$host_port \
	UID=none \
	UPLINK_CAPACITY=100 \
	DOWNLINK_CAPACITY=100 \
	HEADER_TYPE=none \
	CLI_PORT=1080

RUN set -ex \
	&& apk add --no-cache tzdata openssl ca-certificates util-linux bind-tools \
	&& mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
	&& chmod +x v2ray.sh \
	&& ./v2ray.sh

COPY . .

RUN chmod +x v2ray-kcp-entrypoint.sh

CMD ./v2ray-kcp-entrypoint.sh ${HOST} ${PORT} ${HOST_PORT} ${UID} ${UPLINK_CAPACITY} ${DOWNLINK_CAPACITY} ${HEADER_TYPE} ${CLI_PORT}
