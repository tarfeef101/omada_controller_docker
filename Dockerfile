FROM debian:9-slim

RUN apt update && \
    apt -y upgrade && \
    apt -y install mongodb openjdk-8-jre-headless curl jsvc procps net-tools libcap2 && \
    apt purge && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENV OMADA_USER=root
WORKDIR /opt
RUN curl -fsSL https://static.tp-link.com/upload/software/2021/202112/20211217/Omada_SDN_Controller_v4.4.8_linux_x64.tar.gz -o /opt/omada.tgz && \
    tar -xzf /opt/omada.tgz && \
    rm /opt/omada.tgz && \
    sed -i '/${link_name} start/d' install.sh && \
    bash install.sh -y
EXPOSE 8088 8043 8843 29810-29813 29810-29813/udp
COPY entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
