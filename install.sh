#!/bin/sh

###############################################
# centos6.8共通のプロビジョニングスクリプト
#
# 基本的に既にこのスクリプトが実行済みのテンプレートが
# 用意されているので、改めて実行する必要はほとんど無い
###############################################

# ユーザーを作成し、パスワードをユーザー名と同様に設定
echo '--- setting localuser ---'
adduser localuser
echo 'localuser:localuser' |chpasswd

# sudoパッケージをインストールし、localuserにsudoers権限付与
echo '--- setting sudoers'
yum install -y sudo
echo 'localuser ALL=(ALL) ALL' > /etc/sudoers.d/local
chmod 440 /etc/sudoers.d/local

# 日本語環境に対応し、シェルを再起動
echo '--- setting locale ---'
echo 'LANG="ja_JP.utf8"' > /etc/sysconfig/i18n

# 各パッケージのインストール
echo '--- install packages ---'
yum install -y openssh-server git vim wget

# コンテナの再起動
echo '--- reboot now !! ---'
reboot
