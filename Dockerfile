FROM debian:bookworm
ENV LINUX_VERSION=6.9.2

RUN apt update && \
    apt full-upgrade -y && \
    apt install build-essential linux-source bc kmod cpio flex bison libelf-dev libssl-dev \
        libncurses5-dev rsync python3 dwarves wget git debhelper -y

RUN mkdir /root/build
WORKDIR /root/build

RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$LINUX_VERSION.tar.xz -O - | tar xJ
COPY config /root/build/linux-$LINUX_VERSION/.config

WORKDIR /root/build/linux-$LINUX_VERSION/

RUN make oldconfig
RUN scripts/config --disable SECURITY_LOCKDOWN_LSM
RUN scripts/config --disable MODULE_SIG
RUN make -j$(nproc) bindeb-pkg

COPY copy.sh /root/copy.sh

ENTRYPOINT [ "/root/copy.sh" ]
# ENTRYPOINT [ "tail", "-f", "/dev/null" ]
