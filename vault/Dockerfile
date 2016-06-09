FROM alpine:3.3

ENV VAULT_VERSION=0.5.3

ENV DOCKER_BASE_VERSION=0.0.4

RUN addgroup vault && \
    adduser -S -G vault vault

ADD fetch.sh /tmp/fetch.sh

RUN apk add --no-cache ca-certificates gnupg && \
    gpg --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    /tmp/fetch.sh docker-base ${DOCKER_BASE_VERSION} && \
    unzip docker-base_${DOCKER_BASE_VERSION}_linux_amd64.zip && \
    cp bin/gosu bin/dumb-init /bin && \
    /tmp/fetch.sh vault ${VAULT_VERSION} && \
    unzip -d /bin vault_${VAULT_VERSION}_linux_amd64.zip && \
    cd /tmp && \
    rm -rf /tmp/build && \
    apk del gnupg && \
    rm -rf /root/.gnupg

EXPOSE 8200

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["server", "-dev"]


