
github_backup 'default' do
  hostname 'github.example.com'
  dir '/opt/github-backup-utils'
  data_dir '/opt/github-backup-data'
  user 'root'
  group 'root'
  snapshots 10
  schedule 'hourly'
  log_dir '/var/log/github-backup'
  action :create
end
