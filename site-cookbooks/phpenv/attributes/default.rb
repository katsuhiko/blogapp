# Nginx のドキュメントルートのオーナー
default['nginx']['docroot']['owner'] = 'root'
# Nginx のドキュメントルートのグループ
default['nginx']['docroot']['group'] = 'root'
# Nginx のドキュメントルートのパス
default['nginx']['docroot']['path'] = '/usr/share/nginx/html'
# Nginx のドキュメントルートが存在しないときに作成するかどうか
default['nginx']['docroot']['force_create'] = false
# Nginx の default サイト設定に引き渡すパラメータ
default['nginx']['default']['fastcgi_params'] = []
# Nginx でテスト用の VirtualHost を使うかどうか
default['nginx']['test']['available'] = false
# Nginx の test サイト設定に引き渡すパラメータ
default['nginx']['test']['fastcgi_params'] = []
