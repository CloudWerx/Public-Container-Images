FROM alpine:3.13
ARG VERSION=1.16.0
ARG CLOUD_SDK_VERSION=360.0.0

# Inspiration from https://github.com/gmr/alpine-pgbouncer/blob/master/Dockerfile
# hadolint ignore=DL3003,DL3018
RUN \
  # security
  apk add -U --no-cache --upgrade busybox && \
  # Download
  apk add -U --no-cache autoconf autoconf-doc automake udns udns-dev curl gcc libc-dev libevent libevent-dev libtool make openssl-dev pkgconfig postgresql-client && \
  curl -o  /tmp/pgbouncer-$VERSION.tar.gz -L https://pgbouncer.github.io/downloads/files/$VERSION/pgbouncer-$VERSION.tar.gz && \
  cd /tmp && \
  # Unpack, compile
  tar xvfz /tmp/pgbouncer-$VERSION.tar.gz && \
  cd pgbouncer-$VERSION && \
  ./configure --prefix=/usr --with-udns && \
  make && \
  # Manual install
  cp pgbouncer /usr/bin && \
  mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && \
  # entrypoint installs the configuration, allow to write as postgres user
  cp etc/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini.example && \
  cp etc/userlist.txt /etc/pgbouncer/userlist.txt.example && \
  touch /etc/pgbouncer/userlist.txt && \
  addgroup -g 70 -S postgres 2>/dev/null && \
  adduser -u 70 -S -D -H -h /var/lib/postgresql -g "Postgres user" -s /bin/sh -G postgres postgres 2>/dev/null && \
  chown -R postgres /var/run/pgbouncer /etc/pgbouncer && \
  # Sydecar - Install gcloud (for secret manager access)
  # See https://stackoverflow.com/questions/28372328/how-to-install-the-google-cloud-sdk-in-a-docker-image
  mkdir /gcloud && \
  cd /gcloud && \
  apk add --update python3 curl which && \
  #curl -sSL https://sdk.cloud.google.com | bash && \
  curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  ./google-cloud-sdk/install.sh --bash-completion=false --path-update=true --usage-reporting=false && \
  rm -rf $(find google-cloud-sdk/ -regex ".*/__pycache__") && \
  rm -rf google-cloud-sdk/.install/.backup && \
  chown -R postgres /gcloud && \
  chown -R postgres ~/.config/gcloud && \
  # Cleanup
  cd /tmp && \
  rm -rf /tmp/pgbouncer*  && \
  apk del --purge autoconf autoconf-doc automake udns-dev curl gcc libc-dev libevent-dev libtool make libressl-dev pkgconfig

ENV PATH $PATH:/gcloud/google-cloud-sdk/bin
COPY entrypoint.sh /entrypoint.sh
USER postgres
EXPOSE 5432
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]