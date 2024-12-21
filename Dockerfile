FROM debian:bookworm
ENV LINUX_VERSION=6.12.5

RUN apt update && \
    apt full-upgrade -y && \
    apt install build-essential linux-source bc kmod cpio flex bison libelf-dev libssl-dev \
        libncurses5-dev rsync python3 dwarves wget git debhelper -y

RUN mkdir /root/build
WORKDIR /root/build

RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$LINUX_VERSION.tar.xz -O - | tar xJ
COPY config /root/build/linux-$LINUX_VERSION/.config
COPY ./*.patch /root/build/linux-$LINUX_VERSION/

WORKDIR /root/build/linux-$LINUX_VERSION/

RUN make oldconfig
RUN scripts/config --disable SECURITY_LOCKDOWN_LSM
RUN scripts/config --disable MODULE_SIG
RUN scripts/config --enable CONFIG_MSI_EC
RUN scripts/config --enable CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER
RUN make -j$(nproc) bindeb-pkg

COPY copy.sh /root/copy.sh

ENTRYPOINT [ "/root/copy.sh" ]
# ENTRYPOINT [ "tail", "-f", "/dev/null" ]
