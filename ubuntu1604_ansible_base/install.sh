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
echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/local
chmod 440 /etc/sudoers.d/local

# ansible, sshpassをそれぞれインストール
echo '--- install packages ---'
apt install -y ansible sshpass

# コンテナの再起動
echo '--- reboot now !! ---'
reboot
