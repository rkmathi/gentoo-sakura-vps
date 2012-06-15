# Gentoo Linux インストールスクリプト (さくらVPS v3)

## 使い方

https://github.com/kiyoya/gentoo-sakura-vps のほぼ丸パク(ry...Forkです。
tag "kernel-3.2.12"なら一応動くはず...


### OS再インストール

CentOS 6.2 x86_64 (デフォルト) でOS再インストールを実行。
設定したrootパスワードが新システムでも使われる。

### リモートコンソール

Scriptをクローンする。

    cd /root
    git clone git://github.com/rkmathi/gentoo-sakura-vps

make.confを適宜編集し、bootstrap-0-prepare.shを実行する。

    cd /root/gentoo-sakura-vps
    vi make.conf
    ./scripts/bootstrap-0-prepare.sh
    reboot

再起動後、メニューから `Gentoo install` を選択し、Gentooが起動したらbootstrap-1-base.shを実行する。

    cd /root/gentoo-sakura-vps
    ./scripts/bootstrap-1-base.sh
    reboot

再起動後、 root でログイン(パスワードはOS再インストール時のもの)し、ユーザーの作成と公開鍵の設定等を行う。

最後に、bootstrap-3-finalize.shを実行する。

    cd /root/gentoo-sakura-vps
    ./scripts/bootstrap-3-finalize.sh
    reboot

ヾ(＠⌒ー⌒＠)ノ
