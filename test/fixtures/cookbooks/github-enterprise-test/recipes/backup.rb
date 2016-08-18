ghe_dir = '/opt/github/backup-utils'
ghe_config = ::File.join(ghe_dir, 'backup.config')

ghe_backup_utils ghe_dir do
  # hostname 'github.example.com'
  # dir '/opt/github-backup-utils'
  # data_dir '/opt/github-backup-data'
  # user 'root'
  # group 'root'
  # snapshots 10
  # cron '@hourly'
  # log_dir '/var/log/github-backup'
  action :create
end

ghe_backup_config ghe_config do
  hostname 'github.mycompany.com'
  action :create
end

ghe_backup_cron 'default' do
  dir ghe_dir
  config_file ghe_config
  action :create
end
