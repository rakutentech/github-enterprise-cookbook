ghe_backup_utils '/opt/github/backup-utils' do
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

ghe_backup_cron 'default' do
  action :create
end