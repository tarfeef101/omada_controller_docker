FROM debian:10-slim as builder
RUN apt update && \
    apt -y upgrade && \
    apt -y install make gcc default-jdk-headless curl libcap-dev && \
    curl -fsSL https://dlcdn.apache.org//commons/daemon/source/commons-daemon-1.2.4-src.tar.gz -o /opt/apache.tgz && \
    tar -xzf /opt/apache.tgz --strip-components=1 -C /opt && \
    rm /opt/apache.tgz
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
WORKDIR /opt/src/native/unix
RUN ./configure && \
    make

FROM debian:10-slim
# controller has old deps
# install deps other than mongo
# then mongo
# the copy in custom jsvc because its trash until version 1.2.3 (which is very new), and requires jdk8 otherwise
RUN apt update && \
    apt -y upgrade && \
    apt -y install curl libc6 procps net-tools libcap2 gnupg default-jre-headless && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" > /etc/apt/sources.list.d/mongodb-org-5.0.list && \
    apt update && \
    apt install -y mongodb-org && \
    apt -y purge gnupg && \
    apt -y autoremove && \
    apt purge && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /opt/src/native/unix/jsvc /usr/bin/jsvc

ENV OMADA_USER=root
WORKDIR /opt

ARG YEAR
ARG MONTH
ARG DAY
ARG VERSION
# seriously what is even this URL format, why have year and year+month folders if there's a year+month+day folder within
# cmon tp-link
# also why even bother with dates if you're using semver it just makes things uglier and harder to automate
# note: strip-components in untar since v5 to remove top-level folder in tarball that's versioned and unnecessary here
RUN curl -fsSL https://static.tp-link.com/upload/software/${YEAR}/${YEAR}${MONTH}/${YEAR}${MONTH}${DAY}/Omada_SDN_Controller_v${VERSION}_linux_x64.tar.gz -o /opt/omada.tgz && \
    tar -xzf /opt/omada.tgz --strip-components=1 && \
    rm /opt/omada.tgz && \
    sed -i '/${link_name} start/d' install.sh && \
    bash install.sh -y
EXPOSE 8088 8043 8843 29810-29813 29810-29813/udp
COPY entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
