#!/bin/bash

set -e

echo -e "\033[1;33mConfig proxy...\033[0m"
tee /usr/local/bin/proxy <<EOF
#!/bin/bash
http_proxy=http://192.168.1.20:8123 https_proxy=http://192.168.1.20:8123 \$*
EOF
chmod +x /usr/local/bin/proxy

echo -e "\033[1;33mConfig timezone...\033[0m"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone

echo -e "\033[1;33mAdd mritd repo...\033[0m"
cp /vagrant/mritd.repo /etc/yum.repos.d/mritd.repo

echo -e "\033[1;33mUpdating...\033[0m"
yum update -y

echo -e "\033[1;33mInstall Packages...\033[0m"
yum install tmux wget lrzsz vim net-tools zsh bind-utils git -y

echo -e "\033[1;33mInstall oh-my-zsh...\033[0m"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo -e "\033[1;33mInstall Docker...\033[0m"
yum install -y docker-engine-1.12.6-1.el7.centos.x86_64 

echo -e "\033[1;33mSetting Docker Proxy...\033[0m"
mkdir /etc/systemd/system/docker.service.d || true && \
tee /etc/systemd/system/docker.service.d/socks5-proxy.conf <<-EOF
[Service]
Environment="ALL_PROXY=socks5://192.168.1.20:1083"
EOF

echo -e "\033[1;33mStart and enable Docker...\033[0m"
systemctl enable docker
systemctl start docker

#for imageName in `ls /vagrant/kargo_images/*.tar`;do docker load < $imageName;done

echo -e "\033[1;33mConfig ssh...\033[0m"
mkdir ~/.ssh && cat /vagrant/authorized_keys >> ~/.ssh/authorized_keys
sed -i 's/^#RSAAuthentication.*/RSAAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config


