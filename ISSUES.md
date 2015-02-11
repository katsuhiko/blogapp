* CIサーバーが接続するDB設定情報を Nginx test 設定ファイルに書いているため、Chef を流すと消えてしまう。
* Chef, Vagrant 起動後、vagrant provision を実施すると、エラーが発生する。
* Nginx, CakePHPアプリをサブディレクトリで利用できるようにする。今は、app/webroot を直接参照している。
* Apache2, port がかぶり、Nginx が起動しない場合がある。Apache2 を自動起動しないようにするか、アンインストールしたい。
* Jenkins, HTTPS で起動できるようにする。
