#!/bin/bash

# 判断tun0是否存在的
if [ -e /dev/net/tun ]; then
  :
else
  echo "/dev/net/tun doesn't exist. Please create it first." >&2
  exit 1
fi

# 定义一个处理函数，用于在接收到 INT 信号时退出脚本
function cleanup {
  echo "Exiting script..."
  exit 0
}

# 捕获 INT 信号，并调用 cleanup 函数
trap cleanup INT
cd /opt/TopSAP && ./sv_websrv >/home/work/sv_websrv.log 2>&1 &

sleep 1

/home/work/expect.exp

while ! ip address show tun0 > /dev/null; do
    sleep 1
done

danted -f /etc/danted.conf &

# 更改MTU（与 topsap 的默认值保持一致）
ip link set dev tun0 mtu 1300

# 添加NAT转发，使其他请求可以走正常出口，不全部走代理，例如公网请求
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

while sleep 5; do
  if ip link show tun0 | grep -q "mtu 1500"; then
    ip link set dev tun0 mtu 1300
  fi
done
