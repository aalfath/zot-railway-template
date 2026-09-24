# zot v2.1.21 OCI registry with htpasswd auth generated from environment variables.
FROM ghcr.io/project-zot/zot-linux-amd64:v2.1.21@sha256:8258443838e95989c13c891f78a02bc1c391b5a00591ffef24cb8c17cde28038 AS zot

FROM debian:trixie-20260918-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends apache2-utils ca-certificates tini \
 && rm -rf /var/lib/apt/lists/*
COPY --from=zot /usr/local/bin/zot-linux-amd64 /usr/local/bin/zot
COPY config.json /etc/zot/config.template.json
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 5000
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
