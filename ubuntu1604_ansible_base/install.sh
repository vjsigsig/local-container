#!/bin/sh

###############################################
# ubuntu16.04 ansibleサーバー
# 共通プロビジョニングスクリプト
#
# 基本的に既にこのスクリプトが実行済みのテンプレートが
# 用意されているので、改めて実行する必要はほとんど無い
###############################################

# ユーザーを作成し、パスワードをユーザー名と同様に設定
echo '--- setting ansible user ---'
useradd -m ansible
echo 'ansible:ansible' |chpasswd

# ansibleユーザーをsudo使用可能にする
echo '--- setting sudoers ---'
TMPPATH=$(mktemp)
echo 'ansible ALL=(ALL) NOPASSWD:ALL' > ${TMPPATH}
RES=$(visudo -cf ${TMPPATH})
CODE=$?
if [ ${CODE} -ne 0 ]; then
  echo ${RES}
  exit 1
fi
mv ${TMPPATH} /etc/sudoers.d/local
chmod 440 /etc/sudoers.d/local

# ansible, sshpassをそれぞれインストール
echo '--- install packages ---'
apt install -y ansible sshpass

# 日本語化対応
echo '--- update language ---'
locale-gen ja_JP.UTF-8
update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8

# .ssh/configに、フィンガープリントチェックを行わない設定
echo '--- update .ssh/config ---'
echo -e 'Host 10.0.0.*\nStrictHostKeyChecking no\nUserKnownHostsFile=/dev/null' > /home/ansible/.ssh/config
chown ansible. /home/ansible/.ssh/config
chmod 664 /home/ansible/.ssh/config

# コンテナの再起動
echo '--- reboot now !! ---'
reboot
