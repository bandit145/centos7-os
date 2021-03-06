FROM centos:7
MAINTAINER Philip Bove <pgbson@gmail.com>
ENV container docker

# Install systemd -- See https://hub.docker.com/_/centos/
RUN \
    (cd /lib/systemd/system/sysinit.target.wants/ || exit; for i in *; do [ "$i" = systemd-tmpfiles-setup.service ] || rm -f "$i"; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    systemctl mask dev-mqueue.mount dev-hugepages.mount \
      systemd-remount-fs.service sys-kernel-config.mount \
      sys-kernel-debug.mount sys-fs-fuse-connections.mount \
      systemd-logind.service getty.service getty.target; \
    yum -y upgrade; \
    yum -y install dbus dbus-glib dbus-libs dbus-python python-slip-dbus initscripts; \
    yum -y install sudo iproute; \
    yum clean all; \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers;

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]