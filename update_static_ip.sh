#!/bin/bash

# 检查是否以 root 用户身份运行
if [ "$(id -u)" -ne 0 ]; then
    echo "此脚本必须以 root 用户身份运行。退出。"
    exit 1
fi

# 备份原始的 network 配置文件
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak

# 获取用户输入的IP地址和网关
read -p "请输入静态IP地址（例如，192.168.3.200）: " static_ip
read -p "请输入网关地址（例如，192.168.3.1）: " gateway_ip

# 修改 network 配置文件，将动态IP改为静态IP
cat > /etc/netplan/00-installer-config.yaml <<EOL
network:
  version: 2
  ethernets:
    en:
      match:
        name: "eth0"
      addresses:
        - $static_ip/24
      gateway4: $gateway_ip
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOL

# 应用网络配置更改
netplan apply

echo "网络配置已更新为静态IP。"
