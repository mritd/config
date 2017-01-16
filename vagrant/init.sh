#!/bin/bash
yum update -y
yum install tmux wget lrzsz vim net-tools zsh bind-utils git -y
git clone https://github.com/mritd/shell_scripts.git /root/shell_scripts
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

