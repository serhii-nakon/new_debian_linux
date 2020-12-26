To use this new Linux kernel for Debian:
1) You need clone this repository - "git clone https://github.com/serhii-nakon/new_debian_linux.git";
2) Go to path - "cd new_debian_linux";
3) Install Linux image and headers - "sudo apt install ./linux-libc-dev_5.10.1-1_amd64.deb ./linux-image-5.10.1_5.10.1-1_amd64.deb ./linux-headers-5.10.1_5.10.1-1_amd64.deb"

Also need upgrade firmwares from upstream:
1) You need clone this repository in another path - "git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
2) Go to path "cd linux-firmware"
3) Copy all firmwares (or only needed) to "/usr/lib/firmware/" - "sudo cp -r * /usr/lib/firmware/"
