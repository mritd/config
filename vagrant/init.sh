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
cp /vagrant/epel.repo /etc/yum.repos.d/epel.repo
cp /vagrant/mritd.repo /etc/yum.repos.d/mritd.repo

yum update -y
yum install docker-engine-1.12.6-1.el7.centos docker-engine-selinux-1.12.6-1.el7.centos tmux wget lrzsz vim net-tools zsh bind-utils git -y

sudo su root && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo su root && git clone https://github.com/mritd/shell_scripts.git /root/shell_scripts
sudo su root && bash ~/shell_scripts/docker_devicemapper.sh /dev/sda
sudo su root && mkdir /etc/systemd/system/docker.service.d || true && \
tee /etc/systemd/system/docker.service.d/socks5-proxy.conf <<-EOF
[Service]
Environment="ALL_PROXY=socks5://192.168.1.105:1080"
EOF

systemctl enable docker
systemctl start docker
for imageName in `ls /vagrant/kargo_images/*.tar`;do docker load < $imageName;done

sudo su root && mkdir ~/.ssh && cat /vagrant/authorized_keys >> ~/.ssh/authorized_keys
sed -i 's/^#RSAAuthentication.*/RSAAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config
