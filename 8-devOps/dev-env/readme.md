# All configs

sudo cp out/haproxy.cfg /etc/haproxy/haproxy.cfg
sudo cp out/dnsmask.conf /etc/dnsmasq.conf
sudo systemctl restart dnsmasq
sudo systemctl restart haproxy


sudo apt install acl
sudo setfacl -m u:z:rwx /etc/haproxy/haproxy.cfg
sudo getfacl /etc/haproxy/haproxy.cfg
sudo setfacl -m u:z:rw /etc/dnsmasq.conf

# /etc/sudoers
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
z ALL=(root) NOPASSWD: /sbin/ip link add *, /sbin/ip link set *, /sbin/ip link del *, /sbin/ip addr add *
z       ALL=NOPASSWD: /usr/bin/lsof
z       ALL=NOPASSWD: /usr/bin/netstat
z       ALL=NOPASSWD: /usr/local/bin/mitmweb
z       ALL=NOPASSWD: /usr/local/bin/mitmdump
z       ALL=NOPASSWD: /usr/local/bin/mitmproxy
z       ALL=NOPASSWD: /usr/sbin/openvpn
z       ALL=NOPASSWD: /usr/local/bin/termshark
z       ALL=NOPASSWD: /usr/bin/zfs
z       ALL=NOPASSWD: /usr/sbin/zdb
z       ALL=NOPASSWD: /sbin/zpool

# To dnsmask to work:
systemd-resolved/resolved.conf
