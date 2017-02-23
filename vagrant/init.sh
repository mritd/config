#!/bin/bash

set -e

tee /usr/local/bin/proxy <<EOF
#!/bin/bash
http_proxy=http://172.16.0.19:8123 https_proxy=http://172.16.0.19:8123 \$*
EOF

chmod +x /usr/local/bin/proxy

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
cp /vagrant/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
cp /vagrant/docker.repo /etc/yum.repos.d/docker.repo
cp /vagrant/mritd.repo /etc/yum.repos.d/mritd.repo

yum update -y
yum install docker-engine tmux wget lrzsz vim net-tools zsh bind-utils git epel-release -y

sudo su root && sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo su root && git clone https://github.com/mritd/shell_scripts.git /root/shell_scripts
sudo su root && bash ~/shell_scripts/docker_devicemapper.sh /dev/sda
sudo su root && mkdir /etc/systemd/system/docker.service.d || true && \
tee /etc/systemd/system/docker.service.d/socks5-proxy.conf <<-EOF
[Service]
Environment="ALL_PROXY=http://10.10.1.20:8123"
EOF

sudo su root && mkdir ~/.ssh && cat /vagrant/authorized_keys >> ~/.ssh/authorized_keys
sed -i 's/^#RSAAuthentication.*/RSAAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config
