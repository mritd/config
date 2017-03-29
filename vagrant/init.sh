#!/bin/bash

set -e

tee /usr/local/bin/proxy <<EOF
#!/bin/bash
http_proxy=http://192.168.1.110:8123 https_proxy=http://192.168.1.110:8123 \$*
EOF
chmod +x /usr/local/bin/proxy

cp /vagrant/mritd.repo /etc/yum.repos.d/mritd.repo

/usr/local/bin/proxy yum update -y
/usr/local/bin/proxy yum install docker-engine-1.12.6-1.el7.centos docker-engine-selinux-1.12.6-1.el7.centos tmux wget lrzsz vim net-tools zsh bind-utils git -y

sudo su root && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir /etc/systemd/system/docker.service.d || true && \
tee /etc/systemd/system/docker.service.d/socks5-proxy.conf <<-EOF
[Service]
Environment="ALL_PROXY=socks5://192.168.1.110:1083"
EOF

systemctl enable docker
systemctl start docker
#for imageName in `ls /vagrant/kargo_images/*.tar`;do docker load < $imageName;done

mkdir ~/.ssh && cat /vagrant/authorized_keys >> ~/.ssh/authorized_keys
sed -i 's/^#RSAAuthentication.*/RSAAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication\ yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config
