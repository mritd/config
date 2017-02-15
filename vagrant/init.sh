#!/bin/bash

set -e

tee /usr/local/bin/proxy <<EOF
#!/bin/bash
http_proxy=http://192.168.1.120:8123 https_proxy=http://192.168.1.120:8123 \$*
EOF

chmod +x /usr/local/bin/proxy

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
cp /vagrant/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
cp /vagrant/docker.repo /etc/yum.repos.d/docker.repo

yum update -y
yum install docker-engine tmux wget lrzsz vim net-tools zsh bind-utils git -y

sudo su root && sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

git clone https://github.com/mritd/shell_scripts.git /root/shell_scripts

sed -i 's/^#RSAAuthentication.*/RSAAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config

