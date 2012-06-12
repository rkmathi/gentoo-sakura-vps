# Gentoo Linux インストールスクリプト (さくらVPS v3)

## 使い方

https://github.com/kiyoya/gentoo-sakura-vps のほぼ丸パク(ry...Forkです。

### OS再インストール

CentOS 6.2 x86_64 (デフォルト) でOS再インストールを実行。
設定したrootパスワードが新システムでも使われる。

### リモートコンソール

    git clone git://github.com/rkmathi/gentoo-sakura-vps
    cd gentoo-sakura-vps

カレントディレクトリにある make.conf (`/etc/portage/make.conf`) を適宜編集し、

    ./scripts/bootstrap-0-prepare.sh
    reboot

再起動後、`Press any key` と出たら何かキーを押し、メニューから `Gentoo install` を選択。
Gentooが起動したら、

    cd /root/gentoo-sakura-vps
    ./scripts/bootstrap-1-base.sh
    reboot

再起動後したら root でログイン (パスワードはOS再インストール時のもの) し、ユーザーの作成と公開鍵の設定を行う。
その後、

    cd /root/gentoo-sakura-vps
    ./scripts/bootstrap-3-finalize.sh
    reboot

ヾ(＠⌒ー⌒＠)ノ
