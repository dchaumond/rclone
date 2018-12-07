FROM alpine:3.8

ARG RCLONE_VERSION="1.45"
ENV RCLONE_TYPE="amd64"
ENV BUILD_DEPS \
      wget \
      linux-headers \
      unzip
RUN set -x \
    && apk update \
    && apk add --no-cache --virtual .persistent-deps \
       bash \
       curl \
       ca-certificates \
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && cd /tmp  \
    && wget -q http://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-${RCLONE_TYPE}.zip \
    && unzip /tmp/rclone-v${RCLONE_VERSION}-linux-${RCLONE_TYPE}.zip \
    && mv /tmp/rclone-*-linux-${RCLONE_TYPE}/rclone /usr/bin \
    && addgroup -g 1000 rclone \
    && adduser -SDH -u 1000 -s /bin/false rclone -G rclone \
    && rm -Rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && apk del .build-deps

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [""]
