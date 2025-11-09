FROM debian:bookworm-slim

WORKDIR /home/work

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV SERVER_ADDRESS=""
ENV USER_NAME=""
ENV PASSWORD=""

# Install necessary packages and configure timezone
RUN export DEBIAN_FRONTEND=noninteractive && \
    ln -fs /usr/share/zoneinfo/Asia /etc/localtime && \
    apt-get update && \
    apt-get -y --no-install-suggests --no-install-recommends install tzdata sudo curl dante-server iproute2 ca-certificates iptables procps psmisc iputils-ping && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo Ubuntu >> /etc/issue && \
    apt-get install -y expect && \
    curl -o TopSAP-3.5.2.40.2-x86_64.deb -L https://tk.ljcbaby.top/linux/general/x86_64/deb/TopSAP-3.5.2.40.2-x86_64.deb && \
    dpkg -i TopSAP-3.5.2.40.2-x86_64.deb && \
    rm TopSAP-3.5.2.40.2-x86_64.deb && \
    apt-get install -f -y && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh .
COPY danted.conf /etc
COPY expect.exp .

CMD /home/work/start.sh
