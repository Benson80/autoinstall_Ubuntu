#!/bin/bash

# 检查是否以 root 用户身份运行
if [ "$(id -u)" -ne 0 ]; then
    echo "此脚本必须以 root 用户身份运行。退出。"
    exit 1
fi

# 备份原始的 sshd_config 文件
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 使用 sed 命令修改 PermitRootLogin 的设置
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 重启 SSH 服务
systemctl restart ssh

# 修改 root 用户的密码
echo "请设置 root 用户的新密码："
passwd root

echo "sshd_config 文件已更新，PermitRootLogin 设置为 yes，并且 SSH 服务已重启。root 用户的密码已更新。"
