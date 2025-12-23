FROM        --platform=$TARGETOS/$TARGETARCH eclipse-temurin:11-jre-noble

LABEL       author="Maxime Reperant" maintainer="maxime.reperant@freshperf.fr"
LABEL       org.opencontainers.image.source="https://github.com/MaxWgamer/pterodactyl-images"
LABEL       org.opencontainers.image.licenses=MIT

RUN         apt-get update \
            && apt-get install -y --no-install-recommends \
                curl \
                lsof \
                ca-certificates \
                openssl \
                git \
                tar \
                sqlite3 \
                fontconfig \
                tzdata \
                iproute2 \
                libfreetype6 \
                tini \
                zip \
                unzip \
                locales \
                libstdc++6 \
            && locale-gen en_US.UTF-8 \
            && rm -rf /var/lib/apt/lists/*

ENV         LC_ALL=en_US.UTF-8
ENV         LANG=en_US.UTF-8
ENV         LANGUAGE=en_US.UTF-8

RUN         useradd -m -d /home/container -s /bin/bash container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL  SIGINT

COPY        --chown=container:container --chmod=755 ./../entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]