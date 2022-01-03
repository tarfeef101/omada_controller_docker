FROM debian:9-slim
# controller has really old deps, they've told me v5 will address this
# for now, stretch is the easy answer

RUN apt update && \
    apt -y upgrade && \
    apt -y install mongodb openjdk-8-jre-headless curl jsvc procps net-tools libcap2 && \
    apt purge && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENV OMADA_USER=root
WORKDIR /opt

ARG YEAR
ARG MONTH
ARG DAY
ARG VERSION
# seriously what is even this URL format, why have year and year+month folders if there's a year+month+day folder within
# cmon tp-link
# also why even bother with dates if you're using semver it just makes things uglier and harder to automate
RUN curl -fsSL https://static.tp-link.com/upload/software/${YEAR}/${YEAR}${MONTH}/${YEAR}${MONTH}${DAY}/Omada_SDN_Controller_v${VERSION}_linux_x64.tar.gz -o /opt/omada.tgz && \
    tar -xzf /opt/omada.tgz && \
    rm /opt/omada.tgz && \
    sed -i '/${link_name} start/d' install.sh && \
    bash install.sh -y
EXPOSE 8088 8043 8843 29810-29813 29810-29813/udp
COPY entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
